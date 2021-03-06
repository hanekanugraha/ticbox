package ticbox

import grails.converters.JSON
import grails.plugin.shiro.oauth.FacebookOAuthToken
import grails.plugin.shiro.oauth.GoogleOAuthToken
import grails.plugin.shiro.oauth.TwitterOAuthToken
import net.tanesha.recaptcha.ReCaptchaImpl
import net.tanesha.recaptcha.ReCaptchaResponse

//import net.tanesha.recaptcha.ReCaptchaImpl
//import net.tanesha.recaptcha.ReCaptchaResponse
import org.apache.shiro.SecurityUtils
import org.apache.shiro.authc.AuthenticationException
import org.apache.shiro.authc.UsernamePasswordToken
import org.apache.shiro.crypto.hash.Sha256Hash
import org.apache.shiro.grails.ConfigUtils
import org.apache.shiro.web.util.WebUtils
import org.scribe.model.Token
import org.springframework.transaction.TransactionStatus
import org.springframework.web.servlet.support.RequestContextUtils

class AuthController {
    def userService
    def respondentService
    def oauthService

    def index = {
        redirect(action: "login", params: params) }

    def login = {
        return [username: params.username, rememberMe: (params.rememberMe != null), targetUri : params.targetUri]
    }

    def verifyUser = {
        return [username: params.username, rememberMe: (params.rememberMe != null), targetUri: params.targetUri]
    }

    def verifyCode = {
        def targetUri = params.targetUri
        def user = User.findByUsername(params.username)
        if(params.verifyCode==user.verifyCode) {
//            def role = user?.roles?.first()
//            switch (role.name.toLowerCase()) {
//                case "admin":
//                    targetUri = "/admin/index"
//                    break
//                case "surveyor":
//                    targetUri = "/survey/index"
//                    break
//                case "respondent":
//                    targetUri = "/respondent/index"
//                    break
//                default:
//                    targetUri = "/home/index"
//            }

//            def savedRequest = WebUtils.getSavedRequest(request)
//            if (savedRequest) {
//                targetUri = savedRequest.requestURI - request.contextPath
//                if (savedRequest.queryString) targetUri = targetUri + '?' + savedRequest.queryString
//            }
            try {
                user.verify = "1"
                user.save()
            }catch (Exception e){
                log.info(e.getMessage())
                e.printStackTrace()
            }

            flash.message = message(code: "auth.verify.success.default")
            log.info "Redirecting to '${targetUri}'."
            redirect(controller: "auth",action:"login",params:[username: user.username, targetUri: targetUri])
        }
        else{
            flash.error = message(code: "auth.verify.failed")
            redirect(controller: "home",action:"verifyUser",params:[username: user.username, targetUri: targetUri])
        }
    }

    def signIn = {
        def authToken = new UsernamePasswordToken(params.username, params.password as String)

        // Support for "remember me"
        if (params.rememberMe) {
            authToken.rememberMe = true
        }

        try {
            // Perform the actual login. An AuthenticationException
            // will be thrown if the username is unrecognised or the password is incorrect.
            SecurityUtils.subject.login(authToken)

            // If a controller redirected to this page, redirect back to it. Otherwise redirect depends on role
            def targetUri = params.targetUri

            def user = User.findByUsername(SecurityUtils.subject.principal)
            if (user.verify == "0") {
                SecurityUtils.subject.logout()
                redirect(controller: "home",action:"verifyUser",params:[username: user.username, targetUri: targetUri])
                return
            }
            else if (user.status == "0") {
                SecurityUtils.subject.logout()
                redirect(uri:"/home/disableUser",params:[username: user.username])
                return
            }
            def role = user?.roles?.first()
            session.putAt('role', role.name)
            if (!targetUri) {
                    switch (role.name) {
                        case Role.ROLE.ADMIN:
                            targetUri = "/admin/index"
                            break
                        case Role.ROLE.SURVEYOR:
                            targetUri = "/survey/index"
                            break
                        case Role.ROLE.RESPONDENT:
                            targetUri = "/respondent/index"
                            break
                        default:
                            targetUri = "/"
                    }

                    // Handle requests saved by Shiro filters.
                    def savedRequest = WebUtils.getSavedRequest(request)
                    if (savedRequest) {
                        targetUri = savedRequest.requestURI - request.contextPath
                        if (savedRequest.queryString) targetUri = targetUri + '?' + savedRequest.queryString
                    }
            }

            log.info "Redirecting to '${targetUri}'."
            redirect(uri: targetUri)

        } catch (AuthenticationException ex) {
            // Authentication failed, so display the appropriate message on the login page.
            log.info "Authentication failure for user '${params.username}'."
            flash.error = message(code: "auth.login.failed")

            // Keep the username and "remember me" setting so that the user doesn't have to enter them again.
            def m = [username: params.username]
            if (params.rememberMe) {
                m["rememberMe"] = true
            }

            // Remember the target URI too.
            if (params.targetUri) {
                m["targetUri"] = params.targetUri
            }

            // Now redirect back to the login page.
            redirect(uri: "/auth/login", params: m)
        } catch (Exception ex) {
            // Just to make sure, log the user out of the application.
            SecurityUtils.subject.logout()

            log.info "Exception at sign in for user '${params.username}'."
            flash.error = message(code: "auth.general.error")

            // Redirect back to the login page.
            redirect(uri: "/auth/login")
        }
    }

    def signOut = {
        // Log the user out of the application.
        def principal = SecurityUtils.subject?.principal
        SecurityUtils.subject?.logout()
        // For now, redirect back to the home page.
        if (ConfigUtils.getCasEnable() && ConfigUtils.isFromCas(principal)) {
            redirect(uri: ConfigUtils.getLogoutUrl())
        } else {
            redirect(uri: "/")
        }
        ConfigUtils.removePrincipal(principal)
    }

    def unauthorized = {
        flash.error = message(code: "general.auth.notauthorized.message")
        redirect(uri: "/")
    }

    def linkAccount = {
        def cloudUserInfo
        def cloudResponse
        def user = null
        Token token
        String sessionKey
        def authToken = session["shiroAuthToken"]
        try {

            def adminRole = Role.findByName("Surveyor")
            if (authToken instanceof FacebookOAuthToken) {
                sessionKey = oauthService.findSessionKeyForAccessToken('facebook')
                token = session[sessionKey]
                cloudResponse = oauthService.getFacebookResource(token, 'https://graph.facebook.com/me')
                cloudUserInfo = JSON.parse(cloudResponse.body)
                user = User.findByUsername(cloudUserInfo.username)
                if (user == null) {
                    user = userService.createUser([username: cloudUserInfo.username, password: cloudUserInfo.username, email: cloudUserInfo.email])
                }
            } else if (authToken instanceof TwitterOAuthToken) {
                user = User.findByUsername(authToken.principal)
                if (user == null) {
                    user = userService.createUser([username: authToken.principal, password: authToken.principal, email: null])
                }
            } else if (authToken instanceof GoogleOAuthToken) {
                sessionKey = oauthService.findSessionKeyForAccessToken('google')
                token = session[sessionKey]
                cloudResponse = oauthService.getGoogleResource(token, 'https://www.googleapis.com/oauth2/v2/userinfo')
                cloudUserInfo = JSON.parse(cloudResponse.body)
                user = User.findByUsername(cloudUserInfo.name)
                if (user == null) {
                    user = userService.createUser([username: cloudUserInfo.name, password: cloudUserInfo.name, email: cloudUserInfo.email])

                }
            }

            user.addToRoles(adminRole)
            user.save(flush: true)

            forward controller: "shiroOAuth", action: "linkAccount", params: [userId: user.id, targetUri: "/"]

        } catch (Exception e) {
            flash.error = message(code: "app.error.sso.message") + ". " + e.message
            redirect(uri: "/")
        }
    }

    def registerSurveyor = {
        [username: params.username, email: params.email, company: params.company]
    }

    def registerRespondent = {
//        def profileItemList = respondentService.getRespondentProfileItems()
//        [profileItemList: profileItemList, ref: params.ref]
        [ref: params.ref, username: params.username, email: params.email]
    }

    def register =  {
        def errorAction
        try {
            errorAction = ("surveyor".equalsIgnoreCase(params.userType)) ? "registerSurveyor" : "registerRespondent"
            String remoteAddr = request.getRemoteAddr();
            ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
            //reCaptcha.setPrivateKey("6LcX7_0SAAAAAOSBotMxA8-igpdWpclgrKhQfqGz");
            // new privateKey
            reCaptcha.setPrivateKey("6LeTOgMTAAAAABCOKb8mNr2fAlm4mYoNsjtRYni5");

            String challenge = request.getParameter("recaptcha_challenge_field");
            String uresponse = request.getParameter("recaptcha_response_field");

            if(challenge!=null && uresponse!=null && uresponse.length()>0){
                ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

                if (reCaptchaResponse.isValid()) {
                    if(userService.checkExistUsername(params.username)){
                        flash.error = message(code: "auth.register.username.exists")
                        params.username = null
                    }
                    else if(userService.checkExistEmail(params.email)){
                        flash.error = message(code: "auth.register.email.exists")
                        params.email = null
                    }
                    else{
                        userService.createUser(params)
                        flash.message = message(code: "general.create.success.message")
                        redirect(uri: "/")
                    }
                } else {
                    flash.error = message(code: "auth.register.invalid.captcha")
                }
            } else {
                flash.error = message(code: "auth.register.invalid.captcha")
            }

        } catch (Exception e) {
            flash.error = message(code: "auth.register.failed") + " : " + e.message
            log.error(e.message, e)
        }

        forward(action: errorAction)
    }

    def changePassword = {
        def result
        def success = false
        def message
        if (params.id) {
            if (params.oldPassword && params.newPassword && params.confirmPassword) {
                if((params.newPassword).length()>5 || (params.confirmPassword).length()>5) {

                    if (params.newPassword == params.confirmPassword) {
                        def oldPasswordHash = new Sha256Hash(params.oldPassword).toHex()
                        def newPasswordHash = new Sha256Hash(params.newPassword).toHex()
                        def user = User.findByIdAndPasswordHash(params.id, oldPasswordHash)
                        if (user) {
                            user.passwordHash = newPasswordHash

                            user.save()
                            success = true
                            message = "Password successfully changed"
                        } else {
                            message = message(code: "message.password.notmatch")
                        }
                    } else {
                        message = message(code: "message.new-password.missmatch")
                    }

                } else {
                    message = message(code: "message.password.failed")
                }

            } else {
                message = message(code: "message.details.invalid")
            }
        } else {
            message = message(code: "message.user.invalid")
        }
        result = [success: success, message: message]
        render result as JSON
    }

    def resetPassword = {
        def result
        def success = false
//        def message
        if (params.id) {
            if ( params.newPassword && params.confirmPassword) {
                if (params.newPassword == params.confirmPassword) {
                    def newPasswordHash = new Sha256Hash(params.newPassword).toHex()
                    def user = User.findByIdAndResetPassword(params.id, params.resetPassword)
                    if (user) {
                        user.passwordHash = newPasswordHash
                        user.resetPassword=UUID.randomUUID()
                        user.save()
                        success = true
//                        message =

                        flash.message = message(code: "general.resetpassword.success.message")

                    } else {
                        flash.error = message(code: "message.password.invalid")

                    }
                } else {
                    flash.error = message(code: "message.new-password.missmatch")
                }
            } else {
                flash.error = message(code: "message.details.invalid")

            }
        } else {
            flash.error = message(code: "message.user.invalid")
        }
        redirect(uri: "/auth/login")

    }

}
