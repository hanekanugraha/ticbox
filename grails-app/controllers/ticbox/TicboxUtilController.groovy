package ticbox

class TicboxUtilController {

    def surveyService

    def index() {

        render ''

    }

    def bootstrapService

    def reloadBootStrap() {

        bootstrapService.init(servletContext)

        render 'Bootstrap reloaded'

    }

    def checkFreeAddQuestion(){


    }

    def getMaxFreeQuestion() {

        def maxQuestion = Parameter.findByCode("MAX_QUESTION_FREE_SURVEY")

        def jsonStr = null

        if (maxQuestion) {
            jsonStr = com.mongodb.util.JSON.serialize(maxQuestion.value)
        }

        render jsonStr
    }

}
