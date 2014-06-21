package ticbox

import org.grails.datastore.mapping.query.Query

class RespondentService {

    def helperService
    def goldService

    def getProfileItems () {
        return ProfileItem.list()?.sort{it.seq}
    }

    def getSurveyList(RespondentDetail detail){
        //TODO should be fetching only relevant surveys
        def surveys=Survey.findAllBySurveyIdNotInListAndStatus(SurveyResponse.findAllByRespondentId(detail.respondentId).surveyId,Survey.STATUS.IN_PROGRESS)


        return surveys

    }

    def updateRespondentDetail(User respondent, Map<String, String> params) throws Exception {

        def respondentDetail = RespondentDetail.findByRespondentId(respondent.id) ?: new RespondentDetail(respondentId: respondent.id)

        def profileItems = [:]
        def items = ProfileItem.all
        for (Map.Entry<String, String> entry : params.entrySet()) {
            for (ProfileItem item : items) {
                if (entry.value && entry.key.equalsIgnoreCase(item.code)) {

                    switch(item.type){
                        case ProfileItem.TYPES.CHOICE :

                            //TODO all the items must be appended in 1 string
                            profileItems.put(entry.key, entry.value)

                            break

                        case ProfileItem.TYPES.DATE :

                            profileItems.put(entry.key, Date.parse(helperService.getProperty('app.date.format.input', 'dd/MM/yyyy'), entry.value).getTime())

                            break

                        case ProfileItem.TYPES.LOOKUP :

                            //TODO all the items must be appended in 1 string
                            profileItems.put(entry.key, entry.value)

                            break

                        case ProfileItem.TYPES.NUMBER :

                            profileItems.put(entry.key, Integer.valueOf(entry.value))

                            break

                        case ProfileItem.TYPES.STRING :

                            profileItems.put(entry.key, entry.value)

                            break

                        default :

                            break

                    }

                    break
                }
            }
        }

        respondentDetail.profileItems = profileItems
        respondentDetail['username'] = respondent.username
        respondentDetail['email'] = respondent.email

        respondentDetail.save()

        if (respondentDetail.hasErrors()) {
            throw new Exception("Failed to update Respondent Details")
        }
    }

    def getRespondentDetailFromParams(Map<String, String> params) {
        def detail = null
        def profileItems = [:]
        def items = ProfileItem.all
        for (Map.Entry<String, String> entry : params.entrySet()) {
            for (ProfileItem item : items) {
                if (entry.value && entry.key.equalsIgnoreCase(item.code)) {

                    switch(item.type){
                        case ProfileItem.TYPES.CHOICE :

                            //TODO all the items must be appended in 1 string
                            profileItems.put(entry.key, entry.value)

                            break

                        case ProfileItem.TYPES.DATE :

                            profileItems.put(entry.key, Date.parse(helperService.getProperty('app.date.format.input', 'dd/MM/yyyy'), entry.value).getTime())

                            break

                        case ProfileItem.TYPES.LOOKUP :

                            //TODO all the items must be appended in 1 string
                            profileItems.put(entry.key, entry.value)

                            break

                        case ProfileItem.TYPES.NUMBER :

                            profileItems.put(entry.key, Double.valueOf(entry.value))

                            break

                        case ProfileItem.TYPES.STRING :

                            profileItems.put(entry.key, entry.value)

                            break

                        default :

                            break

                    }

                    break
                }
            }
        }
        if (profileItems.size() > 0) {
            detail = new RespondentDetail(respondentId: params.id, profileItems: profileItems)
        }
        return detail
    }

    def saveSurveyReward(String respondentId, String surveyId) throws Exception {
        def respondent = User.findById(respondentId)
        def survey = Survey.findBySurveyId(surveyId)
        if (Survey.POINT_TYPE.GOLD.equalsIgnoreCase(survey.pointType)) {
            goldService.addGoldByTakingSurvey(survey, respondent)
        } else if (Survey.POINT_TYPE.TRUST.equalsIgnoreCase(survey.pointType)) {
            respondent?.respondentProfile?.trust += survey.point
            respondent.save()
        }
    }

    def processReference(String referrer, User reference) {
        if (referrer && reference) {
            User user = User.findByUsername(referrer)
            if (user) {
                user.respondentProfile?.references?.add(reference.username)
                user.save()
                reference.respondentProfile?.referrer = referrer
                reference.save()
            }
        }
    }

}
