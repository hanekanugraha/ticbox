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
}
