dataSource {

}
environments {
    development {
        grails {
            mongo {
                host = "localhost"
                port = 27017
                username = ""
                password = ""
                databaseName = "ticbox"
                //diaglog = 3
            }
        }
    }
    test {
    }
    production {
        grails {
            mongo {
                host = "linus.mongohq.com"
                port = 10012
                username = "heroku"
                password = "ticbox"
                databaseName = "app15680173"
            }
        }
    }
}
