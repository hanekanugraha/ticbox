package ticbox

import org.springframework.context.i18n.LocaleContextHolder

class RespondentService {

    def helperService
    def goldService

    def getProfileItems () {
        return ProfileItem.list()?.sort{it.seq}
    }

    def updateRespondentDetail(Map<String, String> params) throws Exception {
        /* begin Geuis edit */
        def respondent = User.findById(params.id)
        if (respondent == null) {
            //throw apa no?
        }
        /* end Geuis edit */

        def respondentDetail = RespondentDetail.findByRespondentId(params.id)
        respondentDetail = respondentDetail ?: new RespondentDetail(respondentId: params.id).save()
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

        respondentDetail.profileItems = profileItems

        /* begin Geuis edit */
        //respondentDetail['username'] = params.username
        //respondentDetail['email'] = params.email
        respondent['email'] = params.email

        respondent.save()
        if (respondent.hasErrors()) {
            //throw apa no?
        }

        respondentDetail.save()
        if (respondentDetail.hasErrors()) {
            //throw apa no?
        }
        /* end Geuis edit */
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
