package ticbox

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64
import org.apache.shiro.SecurityUtils
import org.apache.shiro.authc.AuthenticationException

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

    def verifyUser = {
        return [username: params.username, rememberMe: (params.rememberMe != null), targetUri: params.targetUri]
    }

    def disableUser ={}

    def verifyUserByEmail() {
        try {
            // def user = User.findByUsernameAndVerify(params.username,"0")
            // Keep the username so that the user doesn't have to enter them again.
            def m = [username: params.username]
            def user = User.findByUsername(params.username)
            if (user && user.verify == "0" && params.verifyCode == user.verifyCode) {
                user.verify = "1"
                userService.updateUser(user)
                //flash.message = message(code: "general.create.success.message")
                //redirect(controller: "home", action: "verifySuccess")
                def role = user?.roles?.first()
                switch (role.name) {
                    case Role.ROLE.SURVEYOR:
                        flash.message = message(code: "auth.verify.success.surveyor")
                        break
                    case Role.ROLE.RESPONDENT:
                        flash.message = message(code: "auth.verify.success.respondent")
                        break
                    default:
                        flash.message = message(code: "auth.verify.success.default")
                }
                redirect(controller: "auth", action: "login", params: m)
            } else if (user && user.verify == "1") {
                flash.message = message(code: "auth.verify.useralreadyverified")
                redirect(controller: "auth", action: "login", params: m)
            } else {
                flash.error = message(code: "auth.verify.failed")
                //log.error(e.message, e)
                redirect(controller: "auth", action: "login")
            }
        }catch (Exception ex) {
            log.info "Verification failure for user '${params.username}'."
            flash.error = message(code: "auth.general.error")
            redirect(uri: "/auth/login")
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
    def getCity  = {
        def cities = City.findAllByParent(params.province)
        def cityList = new ArrayList();

        for(city in cities){
            Map cityMaps= new HashMap();
            cityMaps.put("label",city.label)
            cityMaps.put("code",city.code)
            cityList.add(cityMaps)

        }

        render com.mongodb.util.JSON.serialize(cityList)
    }

    def resetPassword ={
        def user= User.findByEmailAndResetPassword(params.email,params.resetPassword)
        if(user){
            [user:user]
        }
        else{
            redirect(uri: "/auth/login")
        }
    }
}
