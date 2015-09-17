package ticbox

class KnowUsController {

    def index() {}

    def ourStory(){
        if(params.pageID == 'ourStory') {
            redirect(uri: "/knowUs/ourStory/")
        }
    }

    def ourTeam(){}
}
