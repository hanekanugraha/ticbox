import org.apache.shiro.crypto.hash.Sha256Hash
import ticbox.LookupMaster
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
        // todo for dev only but required on Heroku (which automatically set env as Production)
        // todo should only be modified on deployment to real Production or delivery to client
//        Role.collection.drop()
//        User.collection.drop()
//        Parameter.collection.drop()
//        LookupMaster.collection.drop()
//        SurveyResponse.collection.drop()
//        RedemptionRequest.collection.drop()
//        RespondentGoldHistory.collection.drop()
//        RespondentProfile.collection.drop()
//        RespondentDetail.collection.drop()
//
//        // users & roles
//        def adminRole = new Role(name: "Admin")
//        adminRole.permissions = []
//        adminRole.addToPermissions("*:*")
//                 .save()
//
//        def surveyorRole = new Role(name: "Surveyor")
//        surveyorRole.permissions = []
//        surveyorRole.addToPermissions("survey:*")
//                .addToPermissions("ajaxUpload:*")
//                .addToPermissions("ticboxUtil:*")
//   //             .addToPermissions("home:*")
//                .save()
//
//        def respondentRole = new Role(name: "Respondent")
//        respondentRole.permissions = []
//        respondentRole.addToPermissions("respondent:*")
//                .addToPermissions("ajaxUpload:*")
//                .addToPermissions("userNotification:*")
//                .addToPermissions("ticboxUtil:*")
////               .addToPermissions("home:*")
//                .save()
//
//
//        def defaultUser = new User(username: "user123", passwordHash: new Sha256Hash("password").toHex(),verify:"1",status:"1")
//        defaultUser.addToRoles(surveyorRole).save()
//        new SurveyorProfile(
//                email: "user123@gmail.com",
//                companyName: "dev",
//                userAccount: defaultUser
//        ).save()
//
//        def defaultRespondent = new User(username: "respondent1", passwordHash: new Sha256Hash("respondent1").toHex(), respondentProfile: new RespondentProfile(),verify:"1",status:"1")
//        defaultRespondent.addToRoles(respondentRole).save()
//
//        def defaultAdmin = new User(username: "admin", passwordHash: new Sha256Hash("admin").toHex(),verify:"1",status:"1")
//        defaultAdmin.addToRoles(adminRole).save()
//
//        bootstrapService.init()
//
//        //parameters
//        new Parameter(code:"GOLD_RATE_IDR", value: "1000", desc: "Gold to IDR conversion").save()
//        new Parameter(code:"GOLD_MIN_REDEMPTION", value: "50", desc: "Minimum Gold can be redeemed").save()
//        new Parameter(code:"MAX_QUESTION_FREE_SURVEY", value: "20", desc: "Maximum number of Questions/Free Survey").save()
//        new Parameter(code:"MAX_FREE_SURVEY_PER_SURVEYOR", value: "20", desc: "Maximum number of Free Surveys/Surveyor").save()

        println 'should be ok!!....'
    }

    def destroy = {

        bootstrapService.destroy()

    }
}
