package ticbox

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64
import org.apache.shiro.SecurityUtils
import grails.converters.JSON
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.MultipartHttpServletRequest
import uk.co.desirableobjects.ajaxuploader.exception.FileUploadException

class AdminController {
    def userService
    def goldService
    def surveyService
    def itemService
    def respondentService;

    def index() {
        // todo add pagination
        def users = User.all
        def roles = Role.all*.name
        [users: users, userTypes: roles]
    }

    def createUser = {
        try {
            def user = userService.createUser(params)

            // Automatically verified
            user.verify = 1
            userService.updateUser(user)

            flash.message = message(code: "general.create.success.message")
        } catch (Exception e) {
            flash.error = message(code: "general.create.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "index")
    }

    def deleteUsers = {
        try {
            if (params.delUserIds) {
                def delUserIds = ((String) params.delUserIds).split(",")
                userService.deleteUsers(delUserIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No user was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "index")
    }

    def editProfile = {
        try {
            if (params.uid && params.type) {
                if (params.type == "Surveyor") {
                    def user = User.findById(params.uid)
                    def map = [user: user]
                    render(view: "editSurveyorDetail", model: map)

                } else if (params.type == "Respondent") {
                    def detail = RespondentDetail.findByRespondentId(params.uid)
                    def user = User.findById(params.uid)
                    def map = [respondentDetail: detail, user: user]
                    render(view: "editRespondentDetail", model: map)

                } else {
                    throw Exception("Unknown type: " + params.type)
                }
            } else {
                throw Exception("Missing parameters: id or type")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
    }

    def updateRespondentProfile = {
        try {
            if (params.email) {
                User user = User.findByEmail(params.email)
                if (user == null) {
                    throw Exception("User with email = " + params.email + " is not found")
                }

                def params = [
                        'PI_DIVISION001' : params.profileItems_LM_DIVISION001,
                        'PI_ROLE001' : params.profileItems_LM_ROLE001,
                        'PI_GRADE001' : params.profileItems_LM_GRADE001
                ]

                respondentService.updateRespondentDetail(user, params)
                flash.message = message(code: "general.update.success.message")
            } else {
                throw Exception("No user was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.update.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "index")
    }

    def updateSurveyorProfile = {
        try {
            if (params.email) {
                User user = User.findByEmail(params.email)
                if (user == null) {
                    throw Exception("User with email = " + params.email + " is not found")
                }
                flash.message = message(code: "general.update.success.message")
            } else {
                throw Exception("No user was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.update.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "index")
    }

    def redemptions = {
        def redemptionRequestList = RedemptionRequest.findAllByStatus(RedemptionRequest.STATUS.New)
        def redemptionItemRequestList=RedemptionItemRequest.findAllByStatus(RedemptionItemRequest.STATUS.New)
        [redemptionRequestList:redemptionRequestList, redemptionStatuses: RedemptionRequest.STATUS,redemptionItemRequestList:redemptionItemRequestList]
    }

    def updateRedemptionInfo() {
        if (params.type == 'money') {
            def redemption = RedemptionRequest.findById(params.rid)
            redemption.info = params.info
            redemption.save()
        } else if (params.type == 'item') {
            def redemption = RedemptionItemRequest.findById(params.rid)
            redemption.info = params.info
            redemption.save()
        } else {
            String message = "Valid types for redemption: money, item"
            return render(text: [success:false, message: message] as JSON, contentType:'text/json')
        }

        return render(text: [success:true] as JSON, contentType:'text/json')
    }

    def changeRedemptionStatus = {
        try {
            if (params.redemptionIds) {
                def redemptionIds = ((String) params.redemptionIds).split(",")
                goldService.updateRedemptionRequestStatus(redemptionIds, params.newStatus)
                flash.message = message(code: "general.update.success.message")
            } else {
                throw new Exception("Redemption is not found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.update.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "redemptions")
    }

    def surveys ={

        def principal = SecurityUtils.subject.principal
        def admin = User.findByUsername(principal.toString())
        Survey survey = surveyService.getCurrentEditedSurvey()

        [
                inProgress : Survey.findAllByStatus( Survey.STATUS.IN_PROGRESS),
                completes : Survey.findAllByStatus( Survey.STATUS.COMPLETED),
                //submitted : Survey.findAllByStatus( Survey.STATUS.SUBMITTED),
                admin : admin,
                survey: survey,
                //submittedTotal : Survey.findAllByStatus( Survey.STATUS.SUBMITTED).size()
        ]

    }

    def finalizeAndPublishSurvey(){
        try{
            Survey survey=surveyService.getSurvey(params.surveyId)

            surveyService.finalizeAndPublishSurvey(params, survey)

        } catch (Exception e) {
            flash.error = message(code: "general.create.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        forward(action: 'surveys')
        }

    def activeUsers(){
        try {
            if (params.activeUserIds) {
                def activeUserIds = ((String) params.activeUserIds).split(",")
                userService.activeUsers(activeUserIds,params.dactiveReason)
                flash.message = message(code: "general.active.success.message")
            } else {
                throw Exception("No user was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.active.failed.message") + " : " + e.message
            log.error(e.message, e)
            e.printStackTrace()
        }
        redirect(controller: "admin", action: "index")
    }

    def deleteSurveys(){
        try {
            if (params.delSurveyIds) {
                def delSurveyIds = ((String) params.delSurveyIds).split(",")
                surveyService.deleteSurveys(delSurveyIds)
                flash.message = message(code: "app.admin.survey.delete.success.message")
            } else {
                throw Exception("No Surveys was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "app.admin.survey.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "surveys")
    }

    def disableSurveys(){
        try {
            if (params.disableSurveyIds) {
                def disableSurveyIds = ((String) params.disableSurveyIds).split(",")
                surveyService.disableSurveys(disableSurveyIds)
                flash.message = message(code: "app.admin.survey.disable.success.message")
            } else {
                throw Exception("No Surveys was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "app.admin.survey.disable.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "surveys")
    }

    def savePointSurvey() {
        try {
            def surveyId = params.savePointSurveyId
            def surveyPoint = params.surveyPoint

            def survey = surveyService.getSurvey(surveyId)

            if(survey.getEnableStatus()==Survey.ENABLE_STATUS.DISABLE) {
                survey.setPoint(Long.parseLong(surveyPoint))
                surveyService.savePointSurvey(survey)
            } else {
                flash.error = message(code: "app.admin.survey.setpoint.failed.statusenable")
            }
        } catch (Exception e) {
            flash.error = message(code: "app.admin.survey.setpoint.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "surveys")
    }

    def enableSurveys(){
        try {
            if (params.enableSurveyIds) {
                def enableSurveyIds = ((String) params.enableSurveyIds).split(",")
                def para = params
                surveyService.enableSurveys(enableSurveyIds, (String)params.enableBlast)
                flash.message = message(code: "app.admin.survey.enable.success.message")
            } else {
                //throw Exception("No Surveys was found")
                flash.error = message(code: "app.admin.survey.enable.failed.message") + " : No surveys found"
            }
        } catch (Exception e) {
            flash.error = message(code: "app.admin.survey.enable.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "surveys")
    }

    def approveRedemps(){
        try {
            if (params.approveRedempIds) {
                def approveRedempIds = ((String) params.approveRedempIds).split(",")

                goldService.approveRedemptions(approveRedempIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Redemption was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "redemptions")
    }

    def rejectRedemps(){
        try {
            if (params.rejectRedempIds) {
                def rejectRedempIds = ((String) params.rejectRedempIds).split(",")

                goldService.rejectRedemptions(rejectRedempIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Redemption was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "redemptions")
    }

    def listItems(){
        def items=Item.findAllByStatus(Item.STATUS.Active)

        [items:items]
    }

    def createItem ={
        try {
            itemService.createItem(params)
            flash.message = message(code: "general.create.success.message")
        } catch (Exception e) {
            flash.error = message(code: "general.create.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "listItems")

    }

    def deleteItems ={
        try {
            if (params.delItemIds) {
                def delItemIds = ((String) params.delItemIds).split(",")
                itemService.deleteItems(delItemIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No user was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "listItems")
    }

    def approveRedempsItem(){
        try {
            if (params.approveRedempItemIds) {
                def approveRedempItemIds = ((String) params.approveRedempItemIds).split(",")

                itemService.approveRedemptionsItem(approveRedempItemIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Redemption was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "redemptions")
    }

    def rejectRedempsItem(){
        try {
            if (params.rejectRedempItemIds) {
                def rejectRedempItemIds = ((String) params.rejectRedempItemIds).split(",")

                itemService.rejectRedemptionsItem(rejectRedempItemIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Redemption was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "admin", action: "redemptions")
    }

    def uploadItemImage = {
        def message
        try {
            def inputStream
            if (request instanceof MultipartHttpServletRequest) {
                MultipartFile multipartFile = ((MultipartHttpServletRequest) request).getFile("qqfile")
                inputStream = multipartFile.inputStream
            } else {
                inputStream = request.inputStream
            }

            // Update item
            Item item = Item.findById(params.itemId)
            item.pic = Base64.encode(inputStream.bytes)
            item.save()

            if (item.hasErrors()) {
                throw new Exception(item.errors.allErrors.first())
            }

            return render(text: [success:true, img:item.pic] as JSON, contentType:'text/json')
        } catch (FileUploadException e) {
            message = "Failed to upload file."
            log.error(message, e)
        } catch (Exception e) {
            message = "Failed to save item"
            log.error(message, e)
        }
        return render(text: [success:false, message: message] as JSON, contentType:'text/json')
    }

}
