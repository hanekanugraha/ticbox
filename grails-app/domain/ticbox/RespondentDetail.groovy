package ticbox

class RespondentDetail {
    String id
    long respondentId
    Map<String,Object> profileItems  = [:]
    static embedded = ["profileItems"]
    static constraints = {
        profileItems(nullable: true)
    }
}
