package ticbox

class RedemptionRequest {
    static STATUS = [New:"New", Success:"Success", Failed:"Failed"]

    String id
    String respondentId
    String respondentUsername
    String respondentGoldHistoryId
    double redemptionAmount
    String bankName
    String bankBranchName
    String bankAccountNumber
    String bankAccountName
    String remarks
    String status
    String info

    Date dateCreated
    Date lastUpdated
    static constraints = {
        respondentId (blank: false)
        respondentUsername (blank: false)
        respondentGoldHistoryId (nullable: true)
        redemptionAmount (blank: false)
        bankName (blank: false)
        bankBranchName (nullable: true)
        bankAccountNumber (blank: false)
        bankAccountName (blank: false)
        status (blank: false)
        remarks (nullable: true)
    }

}
