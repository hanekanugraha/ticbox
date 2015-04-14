package ticbox

import com.mongodb.DBCollection
import com.mongodb.DBObject
import org.bson.types.ObjectId
import org.codehaus.groovy.grails.web.mapping.LinkGenerator
import org.codehaus.groovy.grails.web.util.WebUtils

class SurveyService {

    def surveyorService
    def helperService
    def emailBlasterService
    def servletContext
    LinkGenerator grailsLinkGenerator

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

    def submitRespondentFilter(String surveyType, String compDateFrom, String compDateTo, String ttlRespondent, String filterItemsJSON, Survey survey){

        def ttlLong = Long.parseLong(ttlRespondent)

        if (survey) {
            if (Survey.SURVEY_TYPE.EASY.equals(surveyType)) {
                DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(filterItemsJSON)

                survey[Survey.COMPONENTS.RESPONDENT_FILTER] = dbObject
                survey.type = surveyType
                survey.completionDateFrom = compDateFrom
                survey.completionDateTo = compDateTo
                survey.ttlRespondent = ttlLong
                survey.save()
            }
        else{
                survey.type = surveyType
                survey.completionDateFrom = compDateFrom
                survey.completionDateTo = compDateTo
                survey.ttlRespondent = ttlLong
                survey.save()
            }


        }
    }

    def submitSurvey(def params, Survey survey){
        if (survey) {
            DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(params.questionItems)

            survey[Survey.COMPONENTS.QUESTION_ITEMS] = dbObject
            survey.title = params.surveyTitle?.encodeAsHTML().replace('\n', '<br/>')

            if(params.logoResourceId){
                def userResource = UserResource.findById(new ObjectId(params.logoResourceId))
                if (userResource) {
                    survey[Survey.COMPONENTS.LOGO] = userResource.id
                }
            }

            survey.save()
        }
    }

    def finalizeAndPublishSurvey(def params, Survey survey) throws Exception {

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

                        def isNotSubscriber = profile.noSubscribe ? (profile.noSubscribe == 'true' ? true : false) : false

                        if (!isNotSubscriber) {
                            recipients << [
                                    email   : profile['email'],
                                    fullname: profile['username'] //TODO RespondentProfile should consists full name
                            ]
                        }
                    }

                    //sending emails to subscribers
                    if (enableBlast == "on") {
                        String serverURL = grailsLinkGenerator.getServerBaseURL()
                        String link = serverURL+"/userNotification?code=${notifCode}"
                        try {
                            emailBlasterService.blastEmail(recipients, 'takeSurvey', 'Take a survey', [link: link, surveyName: survey.name, serverURL: serverURL])
                        } catch (Exception e) {
                            log.error(e.printStackTrace())
                            throw new Exception("Successfully enabled survey(s), but failed to blast emails..")
                        }
                    }
                }
                break

            case Survey.SURVEY_TYPE.FREE :

                break
        }
        survey.point=Long.parseLong(params.surveyPoint)
        survey.status = Survey.STATUS.IN_PROGRESS
        survey.save()

    }

    def submitToAdmin(Survey survey){

        if(survey.type==Survey.SURVEY_TYPE.FREE)
            survey.status=Survey.STATUS.IN_PROGRESS
        else
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

    def getFilteredRespondents(Survey survey, Map criteriaMap){

        def profiles = RespondentDetail.createCriteria().list {
            criteriaMap?.each {criteria ->
                or {
                    isNull(criteria.key)
                    eq criteria.key, criteria.value
                }
            }

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

    def getFilteredSurveys(RespondentDetail respondentDetail){

        StringBuilder sb = new StringBuilder('{ $and: [');

        respondentDetail.profileItems.each {key, val ->

            def profileItem = ProfileItem.findByCode(key)

            switch (profileItem.type){

                case ProfileItem.TYPES.STRING :
                    sb.append("{RESPONDENT_FILTER : { ${'$elemMatch'}: { code: '$key', val: '$val'} } }")
                    break
                case [ProfileItem.TYPES.NUMBER, ProfileItem.TYPES.DATE] :
                    sb.append("{RESPONDENT_FILTER : { ${'$elemMatch'}: { code: '$key', valFrom: {${'$lte'}: $val }, valTo: {${'$gte'}: $val } } }")
                    break

            }

        }

        sb.append(']}')

        DBCollection coll = Survey.collection
        def found = coll.find(com.mongodb.util.JSON.parse(sb.toString()))
        //TODO try to debug here

        return found

    }

    def getSurveyResult(String surveyId){

        Survey survey = getSurvey(surveyId)

        def result = [:]

        if (survey) {
            def questionItems = survey[Survey.COMPONENTS.QUESTION_ITEMS]

            if (questionItems) {

                def surveyResponses = SurveyResponse.findAllBySurveyId(surveyId)

                if (surveyResponses) {

                    for(questionItem in questionItems){
                        def seq = questionItem['seq']

                        if(!result[seq]){
                            result[seq] = [:]
                        }

                        result[seq]['questionItem'] = questionItem

                    }

                    for(surveyResponse in surveyResponses) {

                        if (surveyResponse['response']){

                            for(response in surveyResponse['response']){
                                def answerDetails = response['answerDetails']

                                if (answerDetails && answerDetails['value']) {
                                    def value = answerDetails['value']
                                    def seq = response['seq']
                                    def summary = null

                                    switch (answerDetails['type']){
                                        case Survey.QUESTION_TYPE.CHOICE_SINGLE :

                                            if(!result[seq]['summary']){
                                                summary = [:]
                                            }
                                            else{
                                                summary=result[seq]['summary']
                                            }

                                            value.each{ String choice ->
                                                summary[choice] = summary[choice] ? summary[choice] + 1 : 1
                                            }

                                            break

                                        case Survey.QUESTION_TYPE.CHOICE_MULTIPLE :

                                            if(!result[seq]['summary']){
                                                summary = [:]
                                            }
                                            else{
                                                summary=result[seq]['summary']
                                            }

                                            value.each{ String choice ->
                                                summary[choice] = summary[choice] ? summary[choice] + 1 : 1
                                            }

                                            break

                                        case Survey.QUESTION_TYPE.FREE_TEXT :

                                            if(!result[seq]['summary']){
                                                summary = []
                                            }else{
                                                summary=result[seq]['summary']
                                            }

                                            summary << value

                                            break

                                        case Survey.QUESTION_TYPE.SCALE_RATING :

                                            if(!result[seq]['summary']){
                                                summary = [:]
                                            }else{
                                                summary=result[seq]['summary']
                                            }
                                            for(row in value){
                                                if(!summary[row.key]){
                                                    summary[row.key] = [:]
                                                }

                                                summary[row.key][row.value] = summary[row.key][row.value] ? summary[row.key][row.value] + 1 : 1
                                            }

                                            break

                                        case Survey.QUESTION_TYPE.STAR_RATING :

                                            if(!result[seq]['summary']){
                                                summary = [:]
                                            }else{
                                                summary=result[seq]['summary']
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
                }else {
                    result.error = "No Response found for this survey"
                }
            }else {
                result.error = "No Question Items found for this survey"
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
    def saveResponseFreeSurvey(String responseJSON, String surveyId){
        SurveyResponse surveyResponse = new SurveyResponse(surveyId: surveyId,respondentId: "-1").save()
        DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(responseJSON)
        surveyResponse["response"] = dbObject
        surveyResponse.save()
    }

    def deleteSurvey(def params){
        Survey survey = params.surveyId?Survey.findBySurveyId(params.surveyId):null
        survey.delete()
    }

    def deleteSurveys(String[] ids){
        List<String> delIds = HelperService.getListOfString(ids)
        def surveys = Survey.findAll{
            inList("_id", delIds)
        }
        if (surveys) {
            Survey.deleteAll(surveys)
        } else {
            throw new Exception("No user was found")
        }
    }

    def disableSurveys(String[] ids){
        List<String> enableIds = HelperService.getListOfString(ids)
        def surveys = Survey.findAll{
            inList("_id", enableIds)
        }
        if (surveys) {
            for(i in surveys){
                i.enableStatus=Survey.ENABLE_STATUS.DISABLE;

                def message = 'Your Ticbox Survey with subject ' + i.name + ' is now Inactive.'
                def reason  = ' - '

                System.out.println(message)
                def recipients = []
                recipients << [
                        email : i.surveyor.email,
                        fullname : i.surveyor.userAccount.username
                ]

                try {
                    emailBlasterService.blastEmail(recipients,'disableUser','Your Ticbox Survey is Inactive',[message: message, reason:reason])
                }catch (Exception e){
                    log.error(e.printStackTrace())
                }
            }

            Survey.saveAll(surveys)
        } else {
            throw new Exception("No user was found")
        }
    }

    // kucingkurus
    def enableSurveys(String[] ids){
        List<String> enableIds = HelperService.getListOfString(ids)
        def surveys = Survey.findAll{
            inList("_id", enableIds)
        }
        if (surveys) {
            for(i in surveys){
                i.enableStatus=Survey.ENABLE_STATUS.ENABLE;

                def message = 'Your Ticbox Survey with subject ' + i.name + ' is now Active.'
                def reason  = ' - '

                def recipients = []
                recipients << [
                        email : i.surveyor.email,
                        fullname : i.surveyor.userAccount.username
                ]

                try {
                    emailBlasterService.blastEmail(recipients,'disableUser','Your Ticbox Survey is Active',[message: message, reason:reason])
                }catch (Exception e){
                    log.error(e.printStackTrace())
                }

            }

            Survey.saveAll(surveys)
        } else {
            throw new Exception("No user was found")
        }
    }

    def enableSurveys(String[] ids, String enableBlast) throws Exception {
        List<String> enableIds = HelperService.getListOfString(ids)
        def surveys = Survey.findAll{
            inList("_id", enableIds)
        }
        if (surveys) {
            for (i in surveys) {
                i.enableStatus = Survey.ENABLE_STATUS.ENABLE;
            }

            Survey.saveAll(surveys)

            for (survey in surveys) {
//                    def filteredRespondents = getFilteredRespondents(survey, criteriaMap)
                def filteredRespondents = getFilteredRespondents(survey)

                def recipients = []

                if (filteredRespondents) {

                    String notifCode = "ps_${survey.id}"

                    //TODO find a way for bulky insert
                    for (RespondentDetail profile : filteredRespondents) {
                        UserNotification userNotification = new UserNotification(
                                title: "New survey : ${survey.name}",
                                code: notifCode,
                                username: profile['username'],
                                actionLink: "/respondent/takeSurvey?surveyId=${survey.surveyId}"
                        )

                        userNotification['SERVICE_ID'] = survey.id

                        userNotification.save()

                        def isNotSubscriber = profile.noSubscribe ? (profile.noSubscribe == 'true' ? true : false) : false

                        if (!isNotSubscriber) {
                            recipients << [
                                    email   : profile['email'],
                                    fullname: profile['username'] //TODO RespondentProfile should consists full name
                            ]
                        }
                    }
                    //sending emails to subscribers
                    if (enableBlast == "on") {
                        String serverURL = grailsLinkGenerator.getServerBaseURL()
                        String link = serverURL+"/userNotification?code=${notifCode}"
                        try {
                            emailBlasterService.blastEmail(recipients, 'takeSurvey', 'Take a survey', [link: link, surveyName: survey.name, serverURL: serverURL])
                        } catch (Exception e) {
                            log.error(e.printStackTrace())
                            throw new Exception("Successfully enabled survey(s), but failed to blast emails..")
                        }
                    }
                }
            }

        } else {
            throw new Exception("No survey was found")
        }
    }

    def getCountFreeSurvey(){
        Survey.countBySurveyorAndType(surveyorService.currentSurveyor,Survey.SURVEY_TYPE.FREE)
    }

    def getSurveyorProfileItems () {
        return ProfileItem.findAllByRole(ProfileItem.ROLES.SURVEYOR)?.sort{it.seq}
    }
}
