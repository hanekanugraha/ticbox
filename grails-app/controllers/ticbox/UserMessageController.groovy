package ticbox

import org.apache.shiro.SecurityUtils

class UserMessageController {

    def ticboxUtilsService
    def userMessageService

    def index() {
        def userMessage = UserMessage.findByCodeAndToUsername(params.code, ticboxUtilsService.getPrincipal())

        if(userMessage) {
            userMessage.isRead = true
            userMessage.save()

            redirect controller: '/'
        }else {
            redirect uri: '/'
        }

    }

    def createMessage(){

    }

    def sendMessage(){
        User user = User.findByUsername(params.toUser);
        if(user) {
            userMessageService.createMessage(params,SecurityUtils.subject.principal);
            redirect uri: '/'
        }
        else{
            redirect uri: '/'
        }
    }

    def readMessage(){
        UserMessage userMessage= UserMessage.findById(params.code)

        if(userMessage){
            userMessage.isRead = true
            userMessage.save()
            [fromUserName : userMessage.fromUsername,
             subjectMessage : userMessage.message,
             contentMessage : userMessage.message
            ]
        }
        else{
            redirect uri: '/'
        }
    }

    def oldMessage(){
        def userMessages= UserMessage.findAllByToUsername(SecurityUtils.subject.principal)

        if(userMessages){
            [userMessages:userMessages
            ]
        }
        else{
            redirect uri: '/'
        }
    }

    def deleteMessages(){
        try {
            if (params.delMessageIds) {
                def delMessageIds = ((String) params.delMessageIds).split(",")
                userMessageService.deleteUserMessages(delMessageIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Message was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "userMessage", action: "oldMessage")
    }
}
