package ticbox

import com.gmongo.GMongo
import com.mongodb.MongoClient
import com.mongodb.MongoCredential
import com.mongodb.ServerAddress

import java.text.SimpleDateFormat

/**
 * Created by firmanagustian on 3/8/15.
 */
class SchedulerController {
    SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy")

    def index() {}

    def setCompletionStatus() {
        Date date = new Date()

        try {
            def listSurvey = Survey.findAllByCompletionDateTo(formatter.format(date.minus(1)))

            if(listSurvey.size() != 0) {

                for(survey in listSurvey) {
                    survey.setStatus(Survey.STATUS.COMPLETED);
                    survey.setEnableStatus(Survey.ENABLE_STATUS.DISABLE)
                }
                Survey.saveAll(listSurvey);
            }

            render "OK"
        }catch (e){
            render e.message
        }
    }

}
