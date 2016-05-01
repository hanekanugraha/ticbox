package ticbox

import java.text.SimpleDateFormat
import java.util.Date

class UserNotification {

    String id
    String code
    String username
    String actionLink
    String title
    boolean isNoticed = false
    Date createdDate;

    static constraints = {
    }

    static mapping = {
        username index: true
    }

    static def findAllRelevantByUsername(String username) {
        // TODO: Exclude data older than 1 month
        return findAllByUsernameAndIsNoticed(username, false);
    }

    // db.userNotification.update({'isNoticed': false}, { $set: {'createdDate': new Date()} }, false, true)
    static int countRelevantNotificationSinceLastPeek(String username) {
        def detail = RespondentDetail.findByUsername(username)

        Date startDate = new Date(0)
        if (detail.notificationPeekTime != null) {
            startDate = detail.notificationPeekTime;
        }
        Date endDate = new Date()

        int total = UserNotification.countByUsernameAndIsNoticedAndCreatedDateBetween(username, false, startDate, endDate)

        //System.out.println("+++++++++++++ startDate = " + startDate);
        //System.out.println("+++++++++++++ endDate = " + endDate);
        //System.out.println("+++++++++++++ total = " + total);

        return total;
    }

    static void updatePeekTime(String username) {
        def detail = RespondentDetail.findByUsername(username)
        detail.notificationPeekTime = new Date()
        detail.save()
    }

    def markAsIrrelevant() {
        isNoticed = true;
    }
}
