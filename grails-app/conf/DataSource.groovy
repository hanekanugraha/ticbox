dataSource {

}
environments {
    development {
        grails {
            mongo {

                /*
                host = "localhost"
                port = 27017
                username = ""
                password = ""
                databaseName = "ticbox"
                //diaglog = 3
                */

                host = "kahana.mongohq.com"
                port = 10040
                username = "ticboxnew"
                password = "ticboxnew"
                databaseName = "ticboxnew"

            }
        }
    }
    test {
    }
    production {
        grails {
            mongo {
                host = "kahana.mongohq.com"
                port = 10040
                username = "ticboxnew"
                password = "ticboxnew"
                databaseName = "ticboxnew"
            }
        }
    }
}
