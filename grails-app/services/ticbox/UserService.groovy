package ticbox

import org.apache.shiro.crypto.hash.Sha256Hash
import org.codehaus.groovy.grails.web.mapping.LinkGenerator
import org.codehaus.groovy.grails.web.util.WebUtils

class UserService {
    def respondentService
    def emailBlasterService
    LinkGenerator grailsLinkGenerator

    def createUser(Map params) throws Exception {
        User newUser = new User(
            username: params.username,
            passwordHash: new Sha256Hash(params.password).toHex(),
            email: params.email,
            verify:0,
            verifyCode: generator( (('A'..'Z')+('0'..'9')).join(), 9 ),
            status:1
        )

        newUser.save()

        if (newUser && !newUser.hasErrors()) {
            try {

                Role role

                switch(params.userType){
                    case "surveyor" :
                        role = Role.findByName("Surveyor")

                        new SurveyorProfile(
                                email: params.email,
                                companyName: params.company,
                                userAccount: newUser
                        ).save()
                    break

                    case "respondent" :
                        role = Role.findByName("Respondent")

                        newUser.respondentProfile = new RespondentProfile()
                        newUser.save()
                        params.id = newUser.id
                        respondentService.updateRespondentDetail(newUser, params)
                        // reference point
                        respondentService.processReference(params.referrer, newUser)
                    break

                    case "admin" :
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
            throw new Exception("Error in creating user, ${newUser ? newUser.errors : ''}")
        }

        return newUser
    }

    def deleteUsers(String[] ids) throws Exception {
        List<Long> delIds = HelperService.getListOfLong(ids)
        def users = User.findAll{
            inList("_id", delIds)
        }
        if (users) {
            User.deleteAll(users)
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
            def users = User.findAll{
                inList("_id", activeIds)
            }
            if (users) {
                try {

                    if (users.get(0).getStatus().equals("1")) {
                        for(user in users){
                            user.setStatus("0");
                            def recipients = []
                            recipients << [
                                    email : user.email,
                                    fullname : user.username //TODO RespondentProfile should consists full name
                            ]

                            emailBlasterService.blastEmail(recipients,'disableUser','Disable User',[message: 'message',reason:reason])

                        }
                        User.saveAll(users);
                    } else {
                       for(user in users) {
                           user.status = "1"
                           def recipients = []
                           recipients << [
                                   email : user.email,
                                   fullname : user.username //TODO RespondentProfile should consists full name
                           ]

                           emailBlasterService.blastEmail(recipients,'disableUser','Disable User',[message: 'message',reason:reason])
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

            String link = grailsLinkGenerator.getServerBaseURL()+"/home/resetPassword?email="+email+"&resetPassword="+resetPassword;

            emailBlasterService.blastEmail(recipients, 'forgotPassword', 'Reset Ticbox Password', [link: link])
            user.save()
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
        String link = grailsLinkGenerator.getServerBaseURL()+"/home/verifyUserByEmail?username="+params.username+"&verifyCode="+verifyCode;

        emailBlasterService.blastEmail(recipients,'verifyMail','Verify Code',[verifyCode: verifyCode,verifyLink : link])

    }
}
