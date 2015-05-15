package ticbox

class UserNotificationController {

    def ticboxUtilsService

    def index() {
        def userNotification

        if(params?.containsKey('notif_id')) {
            userNotification = UserNotification.findByIdAndUsername(params.notif_id, ticboxUtilsService.getPrincipal())
        }else {
            /*prioritize the unnoticed first, else just find any matching code*/
            userNotification = UserNotification.findByCodeAndUsernameAndIsNoticed(params.code, ticboxUtilsService.getPrincipal(),false)
            if(!userNotification)
                userNotification = UserNotification.findByCodeAndUsername(params.code, ticboxUtilsService.getPrincipal())
        }

        if(userNotification) {
            userNotification.isNoticed = true
            userNotification.save()

            redirect uri : userNotification.actionLink
        }else {
            redirect uri: '/'
        }

    }
}
