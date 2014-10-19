package ticbox

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64
import org.apache.shiro.SecurityUtils

class HomeController {

    def userService
    def surveyService

    def index() {}
    def ticbox(){

    }
    def forgotPassword(){

    }
    def blastForgotPassword(){
//        try {
            userService.resetPassword(params.email)
            flash.message = message(code: "general.resetpassword.success.message")
//        }catch (Exception e) {
//            flash.error = message(code: "general.resetpassword.nouser.message")
//        }
        redirect (controller: "auth", action: "index")
    }

    def boverifyUser = {
        return [username: params.username, rememberMe: (params.rememberMe != null), targetUri: params.targetUri]
    }

    def disableUser ={}

    def verifyUserByEmail() {
        def user = User.findByUsernameAndVerify(params.username,"0")
        if(user && params.verifyCode==user.verifyCode) {
            user.verify="1"
            userService.updateUser(user)
            flash.message = message(code: "general.create.success.message")
            redirect(controller: "home", action: "verifySuccess")
        }
        else {
            flash.error = message(code: "general.create.failed.message") + " : ${params.username}'"
//            log.error(e.message, e)
            redirect(controller: "auth", action: "login")
        }


    }

    def verifySuccess ={
        return [username: params.username]
    }

    def resendVerifyCode ={

        def user = User.findByUsername(params.username)
        params.put("email",user.email)

        user.verifyCode = userService.generator( (('A'..'Z')+('0'..'9')).join(), 9 )
        userService.sendVerifyCode(params,user.verifyCode)
        userService.updateUser(user)
        flash.message = message(code: "general.create.success.message")
        redirect(controller: "home", action: "verifyUser",params:[username: params.username])
    }

    def takeFreeSurvey = {

        Survey survey = surveyService.getSurveyForRespondent(params.surveyId)
        if(survey.type!=Survey.SURVEY_TYPE.FREE) {

            redirect action: 'index'
        }
        else
            [survey: survey]
    }
    def getSurvey    = {
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
            def surveyResponse = params.surveyResponse
            surveyService.saveResponseFreeSurvey(surveyResponse, params.surveyId)

            render 'SUCCESS'
        } catch (Exception e) {
            log.error(e.message, e)
            render 'FAILED'
        }
    }

    def successTakeFreeSurvey={

    }
}
