package ticbox

import com.gmongo.GMongo

import java.text.SimpleDateFormat

/**
 * Created by firmanagustian on 3/8/15.
 */
class SchedulerController {
    SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy")

    def index() {}

    def setCompletionStatus() {
        try {
            def mongo = new GMongo()

            def db = mongo.getDB("ticboxnew")

            //System.out.println(formatter.format(new Date()))

            db.survey.update([status:Survey.STATUS.IN_PROGRESS, completionDateTo:formatter.format(new Date())], [$set:[status:Survey.STATUS.COMPLETED]])

            render "OK"
        }catch (e){
            render e.message
        }
    }

}
