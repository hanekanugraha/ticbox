package ticbox

import org.apache.shiro.SecurityUtils

class EmailController {

    def index() {
        def emails = Email.findBySendBy(SecurityUtils.subject.principal)

        [emails: emails]

    }

    def createEmail={
        if(params.sendInto!=null){
            for(target in params.sendInto)   {
                def userStatus= [],userRole= [],users

                if (params.userStatus != null) {
                    for(targetStatus in params.userStatus) {
                        userStatus << targetStatus
                    }
                }
                if(params.userRole!=null){
                    for(targetRole in params.userRole) {
                        userRole << targetRole
                    }
                }

                if(params.userStatus!=null&&params.userRole!=null){
                    def roles=Role.findAllByNameInList(userRole)
                    def searchRole=[]
                    for(role in roles) {
                        searchRole << role.id
                    }

                    def user2 = User.createCriteria().list{
                        'in'("roles",["53b39797d05a06f05723b185"])
                    }
                    user2

                }
                else if(params.userStatus!=null){
                    users = User.findAllByStatusInList(userStatus)
                }
                else if(params.userRole!=null){
                    users = User.findAllByRolesInList(Role.findByNameInList(userRole))
                }
                users
            }
        }



        redirect(controller: "email", action: "index")
    }

    def deleteEmails={
        try {
            if (params.delEmailIds) {
                def delEmailIds = ((String) params.delEmailIds).split(",")
                EmailService.deleteEmails(delEmailIds)
                flash.message = message(code: "general.delete.success.message")
            } else {
                throw Exception("No Email was found")
            }
        } catch (Exception e) {
            flash.error = message(code: "general.delete.failed.message") + " : " + e.message
            log.error(e.message, e)
        }
        redirect(controller: "email", action: "index")
    }
}
