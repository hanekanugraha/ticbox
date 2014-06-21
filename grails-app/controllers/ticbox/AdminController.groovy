package ticbox

import org.apache.shiro.SecurityUtils

class AdminController {
    def userService
    def goldService
    def surveyService

    def index() {
        // todo add pagination
        def users = User.all
        def roles = Role.all*.name
        [users: users, userTypes: roles]
    }

    def createUser = {
        try {
            userService.createUser(params)
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

    def redemptions = {
        def redemptionRequestList = RedemptionRequest.all
        [redemptionRequestList:redemptionRequestList, redemptionStatuses: RedemptionRequest.STATUS]
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
                submitted : Survey.findAllByStatus( Survey.STATUS.SUBMITTED),
                admin : admin,
                survey: survey
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

}
