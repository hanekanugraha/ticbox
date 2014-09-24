package ticbox

class RedemptionItemRequest {

    static STATUS = [New:"New", Success:"Success", Failed:"Failed"]
    static COMPONENTS = [ITEMS:'ITEMS']

    String id
    String respondentId
    String respondentUsername
    String respondentGoldHistoryId
    String remarks
    String status
    double goldAmount
    Date dateCreated
    Date lastUpdated
    static constraints = {
        respondentId (blank: false)
        respondentUsername (blank: false)
        respondentGoldHistoryId (nullable: true)
        status (blank: false)
        remarks (nullable: true)
        goldAmount(nullable:false)
    }
}
