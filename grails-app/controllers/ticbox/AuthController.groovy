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
import org.springframework.web.servlet.support.RequestContextUtils

class AuthController {
    def userService
    def respondentService
    def oauthService

    def index = {
        redirect(action: "login", params: params) }

    def login = {
        return [username: params.username, rememberMe: (params.rememberMe != null), targetUri: params.targetUri]
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

            log.info "Redirecting to '${targetUri}'."
            redirect(controller: "auth",action:"login",params:[username: user.username])
        }
        else{
            flash.error = message(code: "verify.failed")
            redirect(controller: "home",action:"verifyUser",params:[username: user.username])
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
            // will be thrown if the username is unrecognised or the
            // password is incorrect.
            SecurityUtils.subject.login(authToken)

            // If a controller redirected to this page, redirect back
            // to it. Otherwise redirect depends on role
            def targetUri = params.targetUri
            if (!targetUri) {
                def user = User.findByUsername(SecurityUtils.subject.principal)
                if (user.verify == "0") {
                    SecurityUtils.subject.logout()
                    redirect(controller: "home",action:"verifyUser",params:[username: user.username])
                }
                else if (user.status == "0") {
                    SecurityUtils.subject.logout()
                    redirect(uri:"/home/disableUser",params:[username: user.username])
                } else {
                    def role = user?.roles?.first()
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
                    session.putAt('role', role.name)

                    // Handle requests saved by Shiro filters.
                    def savedRequest = WebUtils.getSavedRequest(request)
                    if (savedRequest) {
                        targetUri = savedRequest.requestURI - request.contextPath
                        if (savedRequest.queryString) targetUri = targetUri + '?' + savedRequest.queryString
                    }

                    log.info "Redirecting to '${targetUri}'."
                    redirect(uri: targetUri)
                }
            }

        }
        catch (AuthenticationException ex) {
            // Authentication failed, so display the appropriate message
            // on the login page.
            log.info "Authentication failure for user '${params.username}'."
            flash.error = message(code: "login.failed")

            // Keep the username and "remember me" setting so that the
            // user doesn't have to enter them again.
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
        }
        catch (Exception ex) {
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
        def user
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
                    user = new User(username: cloudUserInfo.username, passwordHash: new Sha256Hash(cloudUserInfo.username).toHex(), email: cloudUserInfo.email)
                }
            } else if (authToken instanceof TwitterOAuthToken) {
                user = User.findByUsername(authToken.principal)
                if (user == null) {
                    user = new User(username: authToken.principal, passwordHash: new Sha256Hash(authToken.principal).toHex())
                }
            } else if (authToken instanceof GoogleOAuthToken) {
                sessionKey = oauthService.findSessionKeyForAccessToken('google')
                token = session[sessionKey]
                cloudResponse = oauthService.getGoogleResource(token, 'https://www.googleapis.com/oauth2/v2/userinfo')
                cloudUserInfo = JSON.parse(cloudResponse.body)
                user = User.findByUsername(cloudUserInfo.name)
                if (user == null) {
                    user = new User(username: cloudUserInfo.name, passwordHash: new Sha256Hash(cloudUserInfo.name).toHex(), email: cloudUserInfo.email)
                }
            }
            user.addToRoles(adminRole).save()
            forward controller: "shiroOAuth", action: "linkAccount", params: [userId: user.id, targetUri: "/"]
        } catch (Exception e) {
            flash.error = message(code: "app.error.sso.message") + ". " + e.message
            redirect(uri: "/")
        }
    }

    def registerSurveyor = {}

    def registerRespondent = {
        def profileItemList = respondentService.getProfileItems()
        [profileItemList: profileItemList, ref: params.ref]
    }

    def register = {
        def errorAction
        try {
            errorAction = ("surveyor".equalsIgnoreCase(params.userType)) ? "registerSurveyor" : "registerRespondent"
            String remoteAddr = request.getRemoteAddr();
            ReCaptchaImpl reCaptcha = new ReCaptchaImpl();
            reCaptcha.setPrivateKey("6LfZNf0SAAAAAHWHbxemEPT9puobq6IdHX1v3SUL");

            String challenge = request.getParameter("recaptcha_challenge_field");
            String uresponse = request.getParameter("recaptcha_response_field");
            ReCaptchaResponse reCaptchaResponse = reCaptcha.checkAnswer(remoteAddr, challenge, uresponse);

            if (reCaptchaResponse.isValid()) {
                userService.createUser(params)
                flash.message = message(code: "general.create.success.message")
                redirect(uri: "/")
            } else {
                flash.error = message(code: "general.create.failed.message") + " : "+ "invalid captcha"
                forward(action: errorAction)
            }


        } catch (Exception e) {
            flash.error = message(code: "general.create.failed.message") + " : " + e.message
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
                        message = "Invalid password"
                    }
                } else {
                    message = "New password mismatch"
                }
            } else {
                message = "Please provide all details"
            }
        } else {
            message = "invalid user"
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
                        flash.error = message("Invalid password")

                    }
                } else {
                    flash.error = message("New password mismatch")
                }
            } else {
                flash.error = message("Please provide all details")

            }
        } else {
            flash.error = message("invalid user")
        }
        redirect(uri: "/auth/login")

    }

}
