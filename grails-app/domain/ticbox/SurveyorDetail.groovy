package ticbox

class SurveyorDetail {

    String id
    long surveyorId
    Map<String,Object> profileItems  = [:]
    static embedded = ["profileItems"]
    static constraints = {
        profileItems(nullable: true)
    }
}
