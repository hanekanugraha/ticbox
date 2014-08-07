package ticbox

class HomeController {

    def userService

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
}
