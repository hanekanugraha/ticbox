package ticbox

class Email {

    static SEND_TARGET=[INBOX:"inbox",EMAIL:"email"]

    String emailId
    String sendBy
    String sendOn
    String sendIntoUserTarget
    String sendToUserStatus
    String sendToUserRole
    String sendToUsername
    String subject
    String content

    static constraints = {
    }
}
