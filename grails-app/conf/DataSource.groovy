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
                databaseName = "ticbox-wl"
                */
                //diaglog = 3



                host = "ds037215.mongolab.com"
                port = 37215
                username = "firman"
                password = "redchair45"
                databaseName = "ticboxdb-wl"
                
            }
        }
    }
    test {
    }
    production {
        grails {
            mongo {
                host = "ds037215.mongolab.com"
                port = 37215
                username = "firman"
                password = "redchair45"
                databaseName = "ticboxdb-wl"
            }
        }
    }
}
