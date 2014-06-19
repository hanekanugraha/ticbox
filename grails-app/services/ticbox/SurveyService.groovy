package ticbox

import com.mongodb.DBObject
import org.bson.types.ObjectId
import org.codehaus.groovy.grails.web.util.WebUtils

class SurveyService {

    def surveyorService
    def helperService
    def emailBlasterService
    def servletContext

    def surveyList(){

        return Survey.findAllBySurveyor(surveyorService.getCurrentSurveyor())
    }

    Survey createSurvey(def params){
        SurveyorProfile surveyor = surveyorService.getCurrentSurveyor()

        Survey survey = new Survey(surveyId: UUID.randomUUID().toString(), name: params.surveyName, surveyor: surveyor)

        WebUtils.retrieveGrailsWebRequest().session.putAt('current-edited-survey', survey)

        return survey
    }

    Survey getCurrentEditedSurvey(){
        //TODO should be fetching from current surveyor's edited survey
        Survey survey = WebUtils.retrieveGrailsWebRequest().session.getAt('current-edited-survey')

        //TODO should be fetching from global conf and keep save per survey for locking
        /*survey[Survey.COMPONENTS.SUMMARY_DETAIL] = com.mongodb.util.JSON.parse(
        """{
            chargePerRespondent : "15000",
                totalRespondent : "200"
        }""")*/

        return survey
    }

    def getSurvey(String surveyId) {
        return Survey.findBySurveyId(surveyId)
    }

    def getSurveyForRespondent(String surveyId) {
        return Survey.findBySurveyId(surveyId)
    }

    def getProfileItemsForRespondentFilter(){
        return ProfileItem.list()?.sort{it.seq}
    }

    def submitRespondentFilter(String surveyType, String filterItemsJSON, Survey survey){
        if (survey) {
            if (Survey.SURVEY_TYPE.EASY.equals(surveyType)) {
                DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(filterItemsJSON)

                survey[Survey.COMPONENTS.RESPONDENT_FILTER] = dbObject
            }
            survey.type = surveyType
            survey.save()


        }
    }

    def submitSurvey(def params, Survey survey){
        if (survey) {
            DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(params.questionItems)

            survey[Survey.COMPONENTS.QUESTION_ITEMS] = dbObject
            survey.title = params.surveyTitle

            if(params.logoResourceId){
                def userResource = UserResource.findById(new ObjectId(params.logoResourceId))
                if (userResource) {
                    survey[Survey.COMPONENTS.LOGO] = userResource.id
                }
            }

            survey.save()
        }
    }

    def finalizeAndPublishSurvey(def params, Survey survey){

        switch (survey.type){
            case Survey.SURVEY_TYPE.EASY :

                def filteredRespondents = getFilteredRespondents(survey)

                def recipients = []

                if (filteredRespondents){

                    String notifCode = "ps_${survey.id}"

                    //TODO find a way for bulky insert
                    for (RespondentDetail profile : filteredRespondents){
                        UserNotification userNotification = new UserNotification(
                            title: "New survey : ${survey.name}",
                            code: notifCode,
                            username: profile['username'],
                            actionLink: "/respondent/takeSurvey?surveyId=${survey.surveyId}"
                        )

                        userNotification['SERVICE_ID'] = survey.id

                        userNotification.save()

                        recipients << [
                            email : profile['email'],
                            fullname : profile['username'] //TODO RespondentProfile should consists full name
                        ]
                    }

                    String link = "${servletContext.contextPath}/userNotification?code=${notifCode}"

                    //TODO should be sending bulk emails personally
                    emailBlasterService.blastEmail(recipients, 'takeSurvey', 'Take a survey', [link:link, surveyName: survey.name])

                }


                break
            case Survey.SURVEY_TYPE.FREE :

                break
        }

        survey.status = Survey.STATUS.IN_PROGRESS
        survey.save()

    }

    def submitToAdmin(Survey survey){
        survey.status = Survey.STATUS.SUBMITTED
        survey.save()
    }

    def getFilteredRespondents(Survey survey){

        def profiles = RespondentDetail.createCriteria().list {
            survey[Survey.COMPONENTS.RESPONDENT_FILTER]?.each{filter ->

                switch(filter.type){
                    case ProfileItem.TYPES.CHOICE :

                        or {
                            filter.checkItems?.each{item ->
                                like "profileItems.${filter.code}",  "%${item instanceof Map ? item.key : item}%"
                            }
                        }

                        break

                    case ProfileItem.TYPES.DATE :

                        gte "profileItems.${filter.code}", Date.parse(helperService.getProperty('app.date.format.input', 'dd/MM/yyyy'), filter.valFrom).getTime()
                        lte "profileItems.${filter.code}", Date.parse(helperService.getProperty('app.date.format.input', 'dd/MM/yyyy'), filter.valTo).getTime()

                        break

                    case ProfileItem.TYPES.LOOKUP :

                        or {
                            filter.checkItems?.each{item ->
                                like "profileItems.${filter.code}",  "%${item.key}%"
                            }
                        }

                        break

                    case ProfileItem.TYPES.NUMBER :

                        gte "profileItems.${filter.code}", Double.valueOf(filter.valFrom)
                        lte "profileItems.${filter.code}", Double.valueOf(filter.valTo)

                        break

                    case ProfileItem.TYPES.STRING :

                        like "profileItems.${filter.code}", "%${filter.val}%"

                        break

                    default :

                        break

                }

            }
        }

        return profiles
    }

    def getSurveyResult(String surveyId){

        Survey survey = getSurvey(surveyId)

        def result = [:]

        if (survey) {
            def questionItems = survey[Survey.COMPONENTS.QUESTION_ITEMS]

            if (questionItems){

                for(questionItem in questionItems){
                    def seq = questionItem['seq']

                    if(!result[seq]){
                        result[seq] = [:]
                    }

                    result[seq]['questionItem'] = questionItem

                }

                def surveyResponses = SurveyResponse.findAllBySurveyId(surveyId)

                if (surveyResponses) {

                    for(surveyResponse in surveyResponses) {

                        if (surveyResponse['response']){

                            for(response in surveyResponse['response']){
                                def answerDetails = response['answerDetails']

                                if (answerDetails && answerDetails['value']) {
                                    def value = answerDetails['value']
                                    def seq = response['seq']
                                    def summary = null

                                    switch (answerDetails['type']){
                                        case Survey.QUESTION_TYPE.CHOICE :

                                            if(!summary){
                                                summary = [:]
                                            }

                                            value.each{ String choice ->
                                                summary[choice] = summary[choice] ? summary[choice] + 1 : 1
                                            }

                                            break

                                        case Survey.QUESTION_TYPE.FREE_TEXT :

                                            if(!summary){
                                                summary = []
                                            }

                                            summary << value

                                            break

                                        case Survey.QUESTION_TYPE.SCALE_RATING :

                                            if(!summary){
                                                summary = [:]
                                            }

                                            for(row in value){
                                                if(!summary[row.key]){
                                                    summary[row.key] = [:]
                                                }

                                                summary[row.key][row.value] = summary[row.key][row.value] ? summary[row.key][row.value] + 1 : 1
                                            }

                                            break

                                        case Survey.QUESTION_TYPE.STAR_RATING :

                                            if(!summary){
                                                summary = [:]
                                            }

                                            summary[value] = summary[value] ? summary[row.key][row.value] + 1 : 1

                                            break

                                        default :

                                            break
                                    }

                                    result[seq]['summary'] = summary
                                }
                            }
                        }
                    }
                }

            }


        }



        return result

    }

    def saveResponse(String responseJSON, String surveyId, String respondentId){
        SurveyResponse surveyResponse = SurveyResponse.findBySurveyIdAndRespondentId(surveyId, respondentId) ?: new SurveyResponse(surveyId: surveyId, respondentId: respondentId).save()
        DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(responseJSON)
        surveyResponse["response"] = dbObject
        surveyResponse.save()
    }

    def deleteSurvey(def params){
        Survey survey = params.surveyId?Survey.findBySurveyId(params.surveyId):null
        survey.delete()
    }

}
