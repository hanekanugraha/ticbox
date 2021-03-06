import org.apache.shiro.crypto.hash.Sha256Hash
import ticbox.Coupon
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

        def resetDoc = false

        if (resetDoc) {
            Role.collection.drop()
            User.collection.drop()
            Parameter.collection.drop()
            LookupMaster.collection.drop()
            SurveyResponse.collection.drop()
            RedemptionRequest.collection.drop()
            RespondentGoldHistory.collection.drop()
            RespondentProfile.collection.drop()
            RespondentDetail.collection.drop()

            Survey.collection.drop()
            SurveyorProfile.collection.drop()
            SurveyorDetail.collection.drop()
            UserMessage.collection.drop()
            UserNotification.collection.drop()
            UserResource.collection.drop()

            // users & roles
            def adminRole = new Role(name: "Admin")
            adminRole.permissions = []
            adminRole.addToPermissions("*:*")
                    .save()

            def surveyorRole = new Role(name: "Surveyor")
            surveyorRole.permissions = []
            surveyorRole.addToPermissions("survey:*")
                    .addToPermissions("ajaxUpload:*")
                    .addToPermissions("ticboxUtil:*")
            //         .addToPermissions("home:*")
                    .save()

            def respondentRole = new Role(name: "Respondent")
            respondentRole.permissions = []
            respondentRole.addToPermissions("respondent:*")
                    .addToPermissions("ajaxUpload:*")
                    .addToPermissions("userNotification:*")
                    .addToPermissions("ticboxUtil:*")
            //         .addToPermissions("home:*")
                    .save()


            def defaultUser = new User(username: "user123", passwordHash: new Sha256Hash("password").toHex(),verify:"1",status:"1")
            defaultUser.addToRoles(surveyorRole).save()
            new SurveyorProfile(
                    email: "user123@gmail.com",
                    companyName: "dev",
                    userAccount: defaultUser
            ).save()

            def defaultRespondent = new User(username: "respondent1", passwordHash: new Sha256Hash("respondent1").toHex(), respondentProfile: new RespondentProfile(),verify:"1",status:"1")
            defaultRespondent.addToRoles(respondentRole).save()

            def defaultAdmin = new User(username: "admin", passwordHash: new Sha256Hash("admin").toHex(),verify:"1",status:"1")
            defaultAdmin.addToRoles(adminRole).save()

            bootstrapService.init()
            bootstrapService.initUpdate()

            //parameters
            new Parameter(code:"GOLD_RATE_IDR", value: "1000", desc: "Gold to IDR conversion").save()
            new Parameter(code:"GOLD_MIN_REDEMPTION", value: "50", desc: "Minimum Gold can be redeemed").save()
            new Parameter(code:"MAX_QUESTION_FREE_SURVEY", value: "20", desc: "Maximum number of Questions/Free Survey").save()
            new Parameter(code:"MAX_FREE_SURVEY_PER_SURVEYOR", value: "20", desc: "Maximum number of Free Surveys/Surveyor").save()

            if (!Parameter.findByCode("PRICING_PER_DAY")) {
                new Parameter(code: "PRICING_PER_DAY", value: "200000", desc: "Pricing Per Day").save()
            }
            if (!Parameter.findByCode("PRICING_PER_WEEK")) {
                new Parameter(code: "PRICING_PER_WEEK", value: "800000", desc: "Pricing Per Week").save()
            }
            if (!Parameter.findByCode("PRICING_PER_BIWEEK")) {
                new Parameter(code: "PRICING_PER_BIWEEK", value: "1500000", desc: "Pricing Per Bi Weekly").save()
            }
            if (!Parameter.findByCode("PRICING_PER_TRIWEEK")) {
                new Parameter(code: "PRICING_PER_TRIWEEK", value: "2000000", desc: "Pricing Per Tri Weekly").save()
            }
            if (!Parameter.findByCode("PRICING_PER_MONTH")) {
                new Parameter(code: "PRICING_PER_MONTH", value: "2500000", desc: "Pricing Per MonthLy").save()
            }
            if (!Parameter.findByCode("PRICING_PER_PERSON")) {
                new Parameter(code: "PRICING_PER_PERSON", value: "10000", desc: "Pricing Per Person").save()
            }
            if (!Parameter.findByCode("PRICING_PER_10PERSON")) {
                new Parameter(code: "PRICING_PER_10PERSON", value: "80000", desc: "Pricing Per 10 Person").save()
            }

            if (!Parameter.findByCode("PRICING_PER_50PERSON")) {
                new Parameter(code: "PRICING_PER_50PERSON", value: "80000", desc: "Pricing Per 50 Person").save()
            }

            if (!Parameter.findByCode("PRICING_VAR_PER_FILTER")) {
                new Parameter(code: "PRICING_VAR_PER_FILTER", value: "15", desc: "Pricing Variable Per Filter (In Percentage)").save()
            }

            if (!Parameter.findByCode("PRICING_VAR_PER_10QUESTION")) {
                new Parameter(code: "PRICING_VAR_PER_10QUESTION", value: "5", desc: "Pricing Variable Per 10 Question (In Percentage)").save()
            }

            if (!Coupon.findByCode("DEMOTICBOX")) {
                new Coupon(code: "DEMOTICBOX", description: "Coupon for demo ticbox with very big limit", metric: "A", amount: "99999999999999999", usable: "Y", usableMax: "9999")
            }
        }
        println 'should be ok!!....'
    }

    def destroy = {

        bootstrapService.destroy()

    }
}
