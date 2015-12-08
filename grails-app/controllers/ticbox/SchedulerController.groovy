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
            List<ServerAddress> seeds = new ArrayList<ServerAddress>();
            seeds.add(new ServerAddress("kahana.mongohq.com", 10040))
            // local
//            seeds.add(new ServerAddress("localhost", 27017))


            List<MongoCredential> credentials = new ArrayList<MongoCredential>()
            credentials.add(MongoCredential.createMongoCRCredential("ticboxnew", "ticboxnew","ticboxnew".toCharArray()));

            MongoClient mongoClient = new MongoClient( seeds, credentials )
            // local
            // new MongoClient(seeds)


            def mongo = new GMongo(mongoClient)
            def db = mongo.getDB("ticboxnew")



            db.survey.update([status:Survey.STATUS.IN_PROGRESS, completionDateTo:formatter.format(date.minus(1))],
                             [$set:[status:Survey.STATUS.COMPLETED, enableStatus:Survey.ENABLE_STATUS.DISABLE]])


            render "OK"
        }catch (e){
            render e.message
        }
    }

}
