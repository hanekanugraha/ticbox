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
            LookupMaster lookupMaster=LookupMaster.findByCode(params.lookupCode)
            DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(params.lookupValues)

            lookupMaster.values=dbObject;

            lookupMaster.save()

            render 'SUCCESS'
        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
        redirect action: 'index'
    }
}
