package ticbox

import java.util.Date

class RespondentDetail {
    String id
    long respondentId
    String noSubscribe
    Date notificationPeekTime
    Map<String,Object> profileItems  = [:]
    static embedded = ["profileItems"]
    static constraints = {
        profileItems(nullable: true)
    }
}
