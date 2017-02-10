package ticbox

import grails.transaction.Transactional

@Transactional
class ItemService {

    def createItem(Map params) throws Exception {
        Item newItem = new Item(
                itemName: params.itemName,
                gold: params.gold,
                status: Item.STATUS.Active
        )

        newItem.save()
    }

    def deleteItems(String[] ids) throws Exception {
        List<String> delIds = HelperService.getListOfString(ids)
        def items = Item.findAll{
            inList("_id", delIds)
        }
        if (items) {
            Item.deleteAll(items)
        } else {
            throw new Exception("No items was found")
        }
    }

    def requestItemsRedemption(String[] ids,User user) throws Exception {
        List<String> itemIds = HelperService.getListOfString(ids)
        def items = Item.findAll{
            inList("_id", itemIds)
        }

        def userGold = user.respondentProfile.gold
        double goldToRedeem=0
        for (item in items) {
            goldToRedeem += item.gold
        }


        if (goldToRedeem <= userGold) {
            def history = deductGold(user.id, goldToRedeem, itemIds)
            RedemptionItemRequest request = new RedemptionItemRequest(
                    respondentId:user.id,
                    respondentUsername:user.username,
                    respondentGoldHistoryId:history.id,
                    status:RedemptionRequest.STATUS.New,
                    goldAmount: goldToRedeem
            )
            request[RedemptionItemRequest.COMPONENTS.ITEMS] = ids
            request.save()

        } else {
            throw new Exception("Gold Not Enough")

        }
    }
    def requestItemsRedemption(List itemIds,User user) throws Exception {
//        def items = Item.findAll{
//            inList("_id", itemIds)
//        }

        def goldUser=user.respondentProfile.gold
        double goldRedeem=0
        for(itemId in itemIds){
            def item=Item.findById(itemId)
            goldRedeem+=item.gold
        }


        if (goldRedeem<=goldUser) {
            def history = deductGold(user.id,goldRedeem,itemIds)
            RedemptionItemRequest request= new RedemptionItemRequest(
                    respondentId:user.id,
                    respondentUsername:user.username,
                    respondentGoldHistoryId:history.id,
                    status:RedemptionRequest.STATUS.New,
                    goldAmount: goldRedeem
            )
            request[RedemptionItemRequest.COMPONENTS.ITEMS]=itemIds.toArray()
            request.save()

        } else {
            throw new Exception("Gold Not Enough")
        }
    }

    def deductGold(long respondentId,double goldAmount,List<String> items) throws Exception {

        def history
        def respondent = User.findById(respondentId)
        if (respondent.respondentProfile.gold >= goldAmount){
            def details =""
            for(item in items){
                details+=item+";"
            }
            history = new RespondentGoldHistory(respondentId: respondent.id, description: "Redemption", amount: goldAmount, type: RespondentGoldHistory.TYPES.EXPENSE_REDEMPTION, date: new Date(), details: details, status: RespondentGoldHistory.STATUS.IN_PROGRESS).save()
            respondent.respondentProfile.gold -= goldAmount
            respondent.save()
        } else {
            throw new Exception("Invalid amount")
        }
        return history
    }

    def approveRedemptionsItem(String[] ids){
        List<String> redempIds = HelperService.getListOfString(ids)
        def redempionRequests = RedemptionItemRequest.findAll{
            inList("_id", redempIds)
        }
        if (redempionRequests) {
            for(request in redempionRequests){
                RespondentGoldHistory goldHistory = RespondentGoldHistory.findById(request.respondentGoldHistoryId)
                goldHistory.status = RespondentGoldHistory.STATUS.SUCCESS
                goldHistory.save()
                request.status = RedemptionItemRequest.STATUS.Success
                request.save()
            }
        } else {
            throw new Exception("No Redemption was found")
        }
    }

    def rejectRedemptionsItem(String[] ids) {
        List<String> redempIds = HelperService.getListOfString(ids)
        def redempionRequests = RedemptionItemRequest.findAll {
            inList("_id", redempIds)
        }
        if (redempionRequests) {
            for (request in redempionRequests) {
                RespondentGoldHistory goldHistory = RespondentGoldHistory.findById(request.respondentGoldHistoryId)
                goldHistory.status = RespondentGoldHistory.STATUS.FAILED
                goldHistory.save()
                request.status = RedemptionItemRequest.STATUS.Failed
                request.save()
                def respondent = User.findById(request.respondentId)
                respondent.respondentProfile.gold += goldHistory.amount
                respondent.save()
            }
        } else {
            throw new Exception("No Redemption was found")
        }
    }
}
