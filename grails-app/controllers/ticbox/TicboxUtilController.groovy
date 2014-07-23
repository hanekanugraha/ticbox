package ticbox

class TicboxUtilController {

    def index() {

        render ''

    }

    def bootstrapService

    def reloadBootStrap() {

        bootstrapService.init(servletContext)

        render 'Bootstrap reloaded'

    }

}
