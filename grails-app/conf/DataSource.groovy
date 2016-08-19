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
                //diaglog = 3
*/

                host = "ds037215.mongolab.com"
                port = 37215
                username = "firman"
                password = "redchair45"
                databaseName = "ticboxdb-wl"
/*
                host = "ds045464.mongolab.com"
                port = 45464
                username = "firman"
                password = "redchair45"
                databaseName = "ticboxdb-demo"
*/
//                host = "ds025742.mlab.com"
//                port = 25742
//                username = "firman"
//                password = "redchair45"
//                databaseName = "ticbox-tbl"
            }
        }
    }
    test {
    }
    production {
        grails {
            mongo {
                host = "ds045464.mongolab.com"
                port = 45464
                username = "firman"
                password = "redchair45"
                databaseName = "ticboxdb-demo"
            }

//            mongo {
//                host = "ds025742.mlab.com"
//                port = 25742
//                username = "firman"
//                password = "redchair45"
//                databaseName = "ticbox-tbl"
//            }
        }
    }
}
