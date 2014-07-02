import org.apache.shiro.crypto.hash.Sha256Hash
import ticbox.Parameter
import ticbox.RedemptionRequest
import ticbox.RespondentGoldHistory
import ticbox.RespondentProfile
import ticbox.RespondentDetail
import ticbox.Role
import ticbox.SurveyResponse
import ticbox.SurveyorProfile
import ticbox.User

class BootStrap {

    def bootstrapService

    def init = { servletContext ->
        /*// todo for dev only but required on Heroku (which automatically set env as Production)
        // todo should only be modified on deployment to real Production or delivery to client
        Role.collection.drop()
        User.collection.drop()
        Parameter.collection.drop()
        SurveyResponse.collection.drop()
        RedemptionRequest.collection.drop()
        RespondentGoldHistory.collection.drop()
        RespondentProfile.collection.drop()
        RespondentDetail.collection.drop()

        // users & roles
        def adminRole = new Role(name: "Admin")
        adminRole.permissions = []
        adminRole.addToPermissions("*:*")
                 .save()

        def surveyorRole = new Role(name: "Surveyor")
        surveyorRole.permissions = []
        surveyorRole.addToPermissions("survey:*")
                .addToPermissions("ajaxUpload:*")
                .save()

        def respondentRole = new Role(name: "Respondent")
        respondentRole.permissions = []
        respondentRole.addToPermissions("respondent:*")
                .addToPermissions("ajaxUpload:*")
                .addToPermissions("userNotification:*")
                .save()


        def defaultUser = new User(username: "user123", passwordHash: new Sha256Hash("password").toHex())
        defaultUser.addToRoles(surveyorRole).save()
        new SurveyorProfile(
                email: "user123@gmail.com",
                companyName: "dev",
                userAccount: defaultUser
        ).save()

        def defaultRespondent = new User(username: "respondent1", passwordHash: new Sha256Hash("respondent1").toHex(), respondentProfile: new RespondentProfile())
        defaultRespondent.addToRoles(respondentRole).save()

        def defaultAdmin = new User(username: "admin", passwordHash: new Sha256Hash("admin").toHex())
        defaultAdmin.addToRoles(adminRole).save()

        bootstrapService.init()

        //parameters
        new Parameter(code:"GOLD_RATE_IDR", value: "1000", desc: "Gold to IDR conversion").save()
        new Parameter(code:"GOLD_MIN_REDEMPTION", value: "50", desc: "Minimum Gold can be redeemed").save()*/

        println 'should be ok!!....'
    }

    def destroy = {

        bootstrapService.destroy()

    }
}
