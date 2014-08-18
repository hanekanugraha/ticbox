package ticbox

class UserMessage {

    String id
    //String code

    String toUsername
    String fromUsername

    String message
    String subject
    boolean isRead = false

    static constraints = {
    }

    static mapping = {
        toUsername index: true
    }
}
