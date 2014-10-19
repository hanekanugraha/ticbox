package ticbox

import com.mongodb.DBObject

class LookupMasterController {

    def index() {
        def lookupMasters = LookupMaster.findAll()

        [lookupMasters: lookupMasters]

    }

    def editLookup(){
        LookupMaster lookupMaster=LookupMaster.findByCode(params.code)

        [lookupMaster:lookupMaster]
    }

    def submitLookup= {
        try {
            LookupMaster lm=LookupMaster.findByCode(params.lookupCode)

            lm.values=(DBObject) com.mongodb.util.JSON.parse(params.lookupValues)

            lm.save()
//            render 'SUCCESS'
//            redirect action: 'index'

        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
//        render 'SUCCESS'
        redirect action: 'index'
    }
}
