package ticbox

class GoldService {

    static String delimiter = ";"

    def saveRedemptionRequest(Map params) throws Exception {
        def redemptionAmount = Double.parseDouble(params.redemptionAmount)
        def respondent = User.findById(params.respondentId)
        params.redemptionAmount = redemptionAmount
        params.status = RedemptionRequest.STATUS.New
        def history = deductGold(params)

        def newRequest = new RedemptionRequest(respondentId: respondent.id, respondentUsername: respondent.username, respondentGoldHistoryId: history.id, redemptionAmount: params.redemptionAmount, bankName: params.bankName, bankBranchName: params.bankBranchName, bankAccountNumber: params.bankAccountNumber, bankAccountName: params.bankAccountName, status: params.status).save()
    }

    def deductGold(Map params) throws Exception {
        def goldRateValue = Double.parseDouble(Parameter.findByCode("GOLD_RATE_IDR")?.value)
        def goldAmount = params.redemptionAmount / goldRateValue
        def history
        def respondent = User.findById(params.respondentId)
        if (respondent.respondentProfile.gold >= goldAmount){
            def details = params.bankAccountName + delimiter + params.bankBranchName + delimiter + params.bankAccountNumber + delimiter + params.bankAccountName;
            history = new RespondentGoldHistory(respondentId: respondent.id, description: "Redemption", amount: goldAmount, type: RespondentGoldHistory.TYPES.EXPENSE_REDEMPTION, date: new Date(), details: details, status: RespondentGoldHistory.STATUS.IN_PROGRESS).save()
            respondent.respondentProfile.gold -= goldAmount
            respondent.save()
        } else {
            throw new Exception("Invalid amount")
        }
        return history
    }

    def approveRedemptions(String[] ids){
        List<String> redempIds = HelperService.getListOfString(ids)
        def redempionRequests = RedemptionRequest.findAll{
            inList("_id", redempIds)
        }
        if (redempionRequests) {
            for(request in redempionRequests){
                RespondentGoldHistory goldHistory = RespondentGoldHistory.findById(request.respondentGoldHistoryId)
                goldHistory.status = RespondentGoldHistory.STATUS.SUCCESS
                goldHistory.save()
                request.status = RedemptionRequest.STATUS.Success
                request.save()
                }
        } else {
            throw new Exception("No Redemption was found")
        }
    }

    def rejectRedemptions(String[] ids){
        List<String> redempIds = HelperService.getListOfString(ids)
        def redempionRequests = RedemptionRequest.findAll{
            inList("_id", redempIds)
        }
        if (redempionRequests) {
            for(request in redempionRequests){
                RespondentGoldHistory goldHistory = RespondentGoldHistory.findById(request.respondentGoldHistoryId)
                goldHistory.status = RespondentGoldHistory.STATUS.FAILED
                goldHistory.save()
                request.status = RedemptionRequest.STATUS.Failed
                request.save()
                def respondent = User.findById(request.respondentId)
                respondent.respondentProfile.gold += goldHistory.amount
                respondent.save()
            }
        } else {
            throw new Exception("No Redemption was found")
        }
    }

    def addGoldToReferrer(String description, User respondent, Date date) {
        if (respondent.respondentProfile?.referrer) {
            def rewardParam = Parameter.findByCode("REFERRER_REWARD");
            long reward = (rewardParam) ? Long.parseLong(rewardParam.value) : 0
            def referrer = User.findByUsername(respondent.respondentProfile.referrer)
            new RespondentGoldHistory(respondentId: referrer.id, description: description, amount: reward, type: RespondentGoldHistory.TYPES.INCOME_REFERENCE, date: date, status: RespondentGoldHistory.STATUS.SUCCESS).save()
            referrer.respondentProfile.gold += reward
            referrer.save()
        }
    }

    def addGoldByTakingSurvey(Survey survey, User respondent) {
        // todo use i18n message template
        def desc = survey.title
        def refDesc = respondent.username + " " + survey.title
        def currentDate = new Date()
        def goldHistory = new RespondentGoldHistory(respondentId: respondent.id, description: desc, amount: survey.point, type: RespondentGoldHistory.TYPES.INCOME_SURVEY, date: currentDate, status: RespondentGoldHistory.STATUS.SUCCESS).save()
        respondent?.respondentProfile?.gold += survey.point
        respondent.save()
        addGoldToReferrer(refDesc, respondent, currentDate)
    }

    def getTotalGoldByType(int type, User respondent) {
        def res = 0
        def historyList = respondent.respondentProfile.goldHistory
        historyList?.each {
            res += (type.equals(it.type)) ? it.amount : 0
        }
        return res
    }

    def updateRedemptionRequestStatus(String[] ids, String status) throws Exception {
        def requests = RedemptionRequest.findAll{
            inList("id", ids)
        }
        if (requests) {
            for (RedemptionRequest request : requests) {
                request.status = status
                request.save()
                User respondent = User.findById(request.respondentId)
                RespondentGoldHistory goldHistory = RespondentGoldHistory.findById(request.respondentGoldHistoryId)
                goldHistory.status = getRespondentGoldHistoryStatus(status)
                goldHistory.save()
            }
        } else {
            throw new Exception("No redemption request was found")
        }
    }

    private int getRespondentGoldHistoryStatus(String status) {
        int res = 0;
        switch (status) {
            case RedemptionRequest.STATUS.New :
                res = RespondentGoldHistory.STATUS.IN_PROGRESS
                break
            case RedemptionRequest.STATUS.Failed :
                res = RespondentGoldHistory.STATUS.FAILED
                break
            case RedemptionRequest.STATUS.Success :
                res = RespondentGoldHistory.STATUS.SUCCESS
                break
        }
        return res;
    }
}
