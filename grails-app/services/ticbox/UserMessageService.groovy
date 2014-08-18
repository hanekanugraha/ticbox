package ticbox

import grails.transaction.Transactional
import org.apache.shiro.SecurityUtils

@Transactional
class UserMessageService {

    def createMessage(Map params,String fromUser) {
        UserMessage newMessage = new UserMessage(
            toUsername: params.toUser,
                fromUsername: fromUser,
                subject: params.subjectMessage,
                message: params.contentMessage
        )
        newMessage.save()
        return newMessage
    }

    def deleteUserMessages(String[] ids){
        List<String> delIds = HelperService.getListOfString(ids)
        def userMessages = UserMessage.findAll{
            inList("_id", delIds)
        }
        if (userMessages) {
            UserMessage.deleteAll(userMessages)
        } else {
            throw new Exception("No Message was found")
        }
    }
}
