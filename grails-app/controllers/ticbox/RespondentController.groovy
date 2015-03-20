package ticbox

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64
import grails.converters.JSON
import org.apache.shiro.SecurityUtils
import org.bson.types.ObjectId
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.MultipartHttpServletRequest
import uk.co.desirableobjects.ajaxuploader.exception.FileUploadException

class RespondentController {
    def respondentService
    def surveyService
    def goldService
    def mailService
    def itemService

    def index() {
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())
        def detail = RespondentDetail.findByRespondentId(respondent.id)
        detail = detail ?: new RespondentDetail(respondentId: respondent.id).save()
//        def surveyList = Survey.findByStatus(Survey.STATUS.IN_PROGRESS)
        def surveyList = respondentService.getSurveyList(detail)

        [surveyList:surveyList, respondent: respondent,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def profileForm() {
        def profileItems = respondentService.getRespondentProfileItems()
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())
        def respondentDetail = RespondentDetail.findByRespondentId(respondent.id)
        respondentDetail = respondentDetail ?: new RespondentDetail(respondentId: respondent.id).save()
        [profileItems: profileItems, respondent: respondent, respondentDetail: respondentDetail,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def modify = {
        def respondent = User.findById(params.id)
        respondent.email = params.email
        respondent.save()
        try {
            respondentService.updateRespondentDetail(respondent,params)
            flash.message = message(code: "general.create.success.message")
        } catch (Exception e) {
            flash.message = message(code: "general.create.failed.message")
            log.error(e.message)
        }
        forward(action: "profileForm")
    }

    def uploadImage = {
        def message
        try {
            def inputStream
            if (request instanceof MultipartHttpServletRequest) {
                MultipartFile multipartFile = ((MultipartHttpServletRequest) request).getFile("qqfile")
                inputStream = multipartFile.inputStream
            } else {
                inputStream = request.inputStream
            }

            // update user
            def user = User.findById(params.respondentId)
            user.pic = Base64.encode(inputStream.bytes)
            user.save()

            if (user.hasErrors()) {
                throw new Exception(user.errors.allErrors.first())
            }

            return render(text: [success:true] as JSON, contentType:'text/json')
        } catch (FileUploadException e) {
            message = "Failed to upload file."
            log.error(message, e)
        } catch (Exception e) {
            message = "Failed to save respondent"
            log.error(message, e)
        }
        return render(text: [success:false, message: message] as JSON, contentType:'text/json')
    }

    def viewImage = {
        def user = User.findById(params.respondentId)
        def imageByte
        if (user?.pic) {
            imageByte = Base64.decode(user?.pic)
        }
        response.outputStream << imageByte
    }

    def takeSurvey = {
        def survey = surveyService.getSurveyForRespondent(params.surveyId)
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())
        [survey: survey, respondent: respondent,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def getSurvey = {
        def survey = surveyService.getSurveyForRespondent(params.surveyId)
        def questions = com.mongodb.util.JSON.serialize(survey[Survey.COMPONENTS.QUESTION_ITEMS])
        render questions
    }

    def viewSurveyLogo() {
        def survey = surveyService.getSurveyForRespondent(params.surveyId)

        if (survey[Survey.COMPONENTS.LOGO]) {
            def objectId = survey[Survey.COMPONENTS.LOGO]
            def userResource = UserResource.findById(objectId)
            if (userResource) {
                def imageByte = Base64.decode(userResource[Survey.COMPONENTS.LOGO])
                response.outputStream << imageByte
            }
        }
    }

    def saveResponse(){
        try {

            def survey = surveyService.getSurveyForRespondent(params.surveyId)
            def ttlSurveyResponses = SurveyResponse.findAllBySurveyId(params.surveyId).size()

            if(survey.ttlRespondent>0 && survey.ttlRespondent.minus(1)==ttlSurveyResponses ) {
                
                survey.status = Survey.STATUS.COMPLETED
                survey.enableStatus = Survey.ENABLE_STATUS.DISABLE

                survey.save()
            }

            def surveyResponse = params.surveyResponse
            surveyService.saveResponse(surveyResponse, params.surveyId, params.respondentId)
            respondentService.saveSurveyReward(params.respondentId, params.surveyId)

            render 'SUCCESS'
        } catch (Exception e) {
            log.error(e.message, e)
            render 'FAILED'
        }
    }

    def goldHistory = {
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())
        def goldHistory = RespondentGoldHistory.findAllByRespondentId(respondent.id)
        [goldHistory:goldHistory, respondent: respondent,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def redeemGold = {
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())

        def goldRateValue = Double.parseDouble(Parameter.findByCode("GOLD_RATE_IDR")?.value)
        def goldRate = formatNumber(number: goldRateValue, formatName: "app.currency.format")

        def balanceGoldValue = respondent.respondentProfile?.gold;
        def balanceValue = balanceGoldValue * goldRateValue
        def balance = formatNumber(number: balanceValue, formatName: "app.currency.format")

        def minRedemptionPointValue = Double.parseDouble(Parameter.findByCode("GOLD_MIN_REDEMPTION")?.value)
        def minRedemptionValue = minRedemptionPointValue * goldRateValue

        [maxRedemption: balanceValue, minRedemption:minRedemptionValue, goldRate:goldRate, balance:balance, respondent: respondent,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def requestRedemption = {
        try {
            def principal = SecurityUtils.subject.principal
            def respondent = User.findByUsername(principal.toString())
            params.respondentId = respondent.id
            goldService.saveRedemptionRequest(params)
            render 'SUCCESS'
        } catch (Exception e) {
            log.error(e.message, e)
            render 'FAILED'
        }
    }

    def inviteFriends = {
        def principal = SecurityUtils.subject.principal
        def respondent = null
        def fbAppId = null
        def totalGold = 0
        try {
            respondent = User.findByUsername(principal.toString())
            fbAppId = grailsApplication.config.oauth.providers.facebook.key
            totalGold = goldService.getTotalGoldByType(RespondentGoldHistory.TYPES.INCOME_REFERENCE, respondent)
        } catch (Exception e) {
            log.error(e.message, e)
        }
        [respondent: respondent, refLink: getRespondentReferenceLink(respondent), fbAppId:fbAppId, totalGold: totalGold,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def inviteByEmail = {
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())
        def emails = prepareEmails(params.friendEmails)
        def emailFrom = message(code: "ticbox.respondent.invite.email.from")
        def emailSubject = message(code: "ticbox.respondent.invite.email.subject")
        def emailBody = message(code: "ticbox.respondent.invite.email.body", args: [getRespondentReferenceLink(respondent)])
        try {
            mailService.sendMail {
                to emails
                from emailFrom
                subject emailSubject
                html emailBody
            }
            render 'SUCCESS'
        } catch (Exception e) {
            log.error(e.message, e)
            render 'FAILED'
        }
    }

    private String[] prepareEmails(String rawEmails) {
        def res = null
        if (rawEmails) {
            def arrayEmails = rawEmails.split(",")
            for (int i = 0; i < arrayEmails.length; i++) {
                arrayEmails[i] = arrayEmails[i].trim().replaceAll(" ","")
            }
            res = (arrayEmails.length > 0) ? arrayEmails : null
        }
        return res;
    }

    private String getRespondentReferenceLink(User respondent) {
        return "${g.createLink(controller: 'auth', action: 'registerRespondent', absolute: true)}?ref=${respondent.username}"
    }

    def redeemItems = {
        def principal = SecurityUtils.subject.principal
        def respondent = User.findByUsername(principal.toString())

        def items=Item.findAllByStatus(Item.STATUS.Active)

        [items:items,respondent: respondent,surveyJoined:SurveyResponse.countByRespondentId(respondent.id)]
    }

    def requestItemsRedemption={
        try {
            if (params.redeemItemIds) {
                def redeemItemIds = ((String) params.redeemItemIds).split(",")
                def principal = SecurityUtils.subject.principal
                def respondent = User.findByUsername(principal.toString())
                itemService.requestItemsRedemption(redeemItemIds,respondent)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Item was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "respondent", action: "redeemItems")
    }



    def requestItemsRedemptionCart={
        def listItem=[];
        try{
            int count=Integer.parseInt(params.itemCount)
            def principal = SecurityUtils.subject.principal
            def respondent = User.findByUsername(principal.toString())

            for(int i=1;i<=count;i++){
                int quantity=Integer.parseInt(params.get("item_quantity_"+i));
                for(int j =1;j<=quantity;j++) {
                    listItem << params.get("item_code_" + i)
                }
            }
            itemService.requestItemsRedemption(listItem,respondent)
            flash.message = message(code: "general.delete.success.message")

        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "respondent", action: "redeemItems")

    }


}
