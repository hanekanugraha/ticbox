package ticbox

import org.apache.shiro.crypto.hash.Sha256Hash
import org.codehaus.groovy.grails.web.mapping.LinkGenerator
import org.codehaus.groovy.grails.web.util.WebUtils

class UserService {
    def respondentService
    def emailBlasterService
    LinkGenerator grailsLinkGenerator

    User createUser(def params) throws Exception {
        User newUser = new User(
            username: params.username,
            passwordHash: new Sha256Hash(params.password).toHex(),
            email: params.email,
            verify:0,
            verifyCode: generator( (('A'..'Z')+('0'..'9')).join(), 9 ),
            status:1
        )

        newUser.save(flush: true)

        if (newUser && !newUser.hasErrors() && params.userType) {
            try {

                Role role

                switch(params.userType){
                    case "Surveyor" :
                        role = Role.findByName("Surveyor")

                        new SurveyorProfile(
                                email: params.email,
                                companyName: params.company,
                                userAccount: newUser
                        ).save()
                    break

                    case "Respondent" :
                        role = Role.findByName("Respondent")

                        newUser.respondentProfile = new RespondentProfile()
                        newUser.save()
                        params.id = newUser.id
                        respondentService.updateRespondentDetail(newUser, params)
                        // reference point
                        respondentService.processReference(params.referrer, newUser)
                    break

                    case "Admin" :
                        role = Role.findByName("Admin")
                    break
                }

                if (role) {
                    newUser.roles = [role]

                }else{
                    throw new Exception("Cannot get user's role")
                }
                newUser.save()
                try {
                    sendVerifyCode(params, newUser.verifyCode)
                }catch (Exception e){
                    log.error(e.getMessage())
                    //throw new Exception("Error sending email, ${e.message}")
                }


            } catch (e) {
                throw new Exception("Error in creating profile, ${e.message}")
            }
        }else{
//            throw new Exception("Error in creating user, ${newUser ? newUser.errors : ''}")
            log.error "Error in creating user '${params.username}'."
            flash.error = message(code: "auth.general.error")
        }

        return newUser
    }

    def deleteUsers(String[] ids) throws Exception {
        List<Long> delIds = HelperService.getListOfLong(ids)
        def users = User.findAll{
            inList("_id", delIds)
        }
        if (users) {
            for(user in users){
                if(user.respondentProfile){
                    user.respondentProfile.delete()
                }
                def notifications = UserNotification.findAllByUsername(user.username)
                UserNotification.deleteAll(notifications)

                def messages = UserMessage.findAllByFromUsernameOrToUsername(user.username, user.username)
                UserMessage.deleteAll(messages)

                def role = user?.roles?.first()
                switch(role.name){
                    case Role.ROLE.ADMIN:
                        break
                    case Role.ROLE.RESPONDENT:
                        def respondentDetails = RespondentDetail.findAllByRespondentId(user.id)
                        RespondentDetail.deleteAll(respondentDetails)

                        def goldHists = RespondentGoldHistory.findAllByRespondentId(user.id)
                        RespondentGoldHistory.deleteAll(goldHists)

                        def redemptionItemRequests = RedemptionItemRequest.findAllByRespondentId(user.id)
                        RedemptionItemRequest.deleteAll(redemptionItemRequests)

                        def redemptionRequests = RedemptionRequest.findAllByRespondentId(user.id)
                        RedemptionRequest.deleteAll(redemptionRequests)
                        break
                    case Role.ROLE.SURVEYOR:
                        def surveyorDetails = SurveyorDetail.findAllBySurveyorId(user.id)
                        SurveyorDetail.deleteAll(surveyorDetails)

                        def surveyorProfiles = SurveyorProfile.findAllByUserAccount(user)
                        SurveyorProfile.deleteAll(surveyorProfiles)
                        //surveys & surveyresults?
                        break
                    default:
                        break
                }

                user.roles.clear()
                user.delete()
            }
        } else {
            throw new Exception("No user was found")
        }
    }

    def generator = { String alphabet, int n ->
        new Random().with {
            (1..n).collect { alphabet[ nextInt( alphabet.length() ) ] }.join()
        }
    }

    def activeUsers(String[] ids,String reason) throws Exception {
        List<Long> activeIds = HelperService.getListOfLong(ids)
            def users = User.findAll {
                inList("_id", activeIds)
            }
            if (users) {
                String serverURL = grailsLinkGenerator.getServerBaseURL()
                try {
                    if (users.get(0).getStatus().equals("1")) {
                        // deactivate user
                        System.out.println('acc enable to disable')
                        for(user in users){
                            user.setStatus("0");
                            def recipients = []
                            recipients << [
                                    email : user.email,
                                    fullname : user.username //TODO RespondentProfile should consists full name
                            ]

                            emailBlasterService.blastEmail(recipients,'disableUser','Your Ticbox Account is Inactive',[message: 'Your Ticbox account is now disabled.',reason:reason, serverURL:serverURL])

                        }
                        User.saveAll(users);
                    } else if(users.get(0).getStatus().equals("0")) {
                        // activate user
                        for(user in users) {
                            user.setStatus("1");
                            def recipients = []
                            recipients << [
                                    email : user.email,
                                    fullname: user.username
                            ]

                            emailBlasterService.blastEmail(recipients, 'disableUser', 'Your Ticbox Account is Active', [message: 'Your Ticbox account is now enabled.', reason:reason, serverURL:serverURL])
                        }
                        User.saveAll(users)
                    } else {
                       for(user in users) {
                           // other status
                           System.out.println('status yang gak terdaftar')
                           user.status = "1"
                           def recipients = []
                           recipients << [
                                   email : user.email,
                                   fullname : user.username //TODO RespondentProfile should consists full name
                           ]

                           emailBlasterService.blastEmail(recipients,'disableUser','Your Ticbox Account is Inactive',[message: 'Your Ticbox account is now disabled.',reason:reason, serverURL:serverURL])
                       }
                        User.saveAll(users);

                    }
                }catch (e) {
                    throw new Exception("Error in update user, ${e.message}")
                }
            } else {
                throw new Exception("No user was found")
            }
    }

    def resetPassword(String email){
//        String newPassword =generator( (('A'..'Z')+('0'..'9')).join(), 9 )
//        String passwordHash= new Sha256Hash(newPassword).toHex()
        String resetPassword=UUID.randomUUID().toString()
        def recipients = []
        User user= User.findByEmail(email)

        if(user) {
            user.resetPassword=resetPassword

            recipients << [
                    email   : user.email,
                    fullname: user.username //TODO RespondentProfile should consists full name
            ]

            String serverURL = grailsLinkGenerator.getServerBaseURL()
            String link = serverURL+"/home/resetPassword?email="+email+"&resetPassword="+resetPassword;

            emailBlasterService.blastEmail(recipients, 'forgotPassword', 'Ticbox: Reset Password', [link: link, serverURL: serverURL])
            user.save()
        } else {
            return false;
        }
        return true
    }

    def updateUser(User user){
        user.save()
    }

    def sendVerifyCode(Map params,String verifyCode){

        def recipients = []
        recipients << [
                email : params.email,
                fullname : params.username //TODO RespondentProfile should consists full name
        ]

        String serverURL = grailsLinkGenerator.getServerBaseURL()
        String link = grailsLinkGenerator.getServerBaseURL()+"/home/verifyUserByEmail?username="+params.username+"&verifyCode="+verifyCode;

        emailBlasterService.blastEmail(recipients,'verifyMail','Ticbox: Email Verification',[verifyCode: verifyCode, verifyLink : link, serverURL: serverURL])

    }

    def User checkExistEmail(String email){
        return User.findByEmail(email)
    }

    def User checkExistUsername(String username){
        return User.findByUsername(username)
    }
}
