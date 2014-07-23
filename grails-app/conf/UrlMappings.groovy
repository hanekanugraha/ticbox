class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?"{
            constraints {
                // apply constraints here
            }
        }

        "/oauth/success"(controller: "shiroOAuth", action: "onSuccess")
        "/oauth/callback/$provider"(controller: "oauth", action: "callback")
        "/"(controller: "home", action: "index")
        "500"(view:'/error')

        "/policies/termsOfUse"(controller: "policies",action: "termsOfUse")
        "/policies/privacy"(controller: "policies",action: "privacy")
        "/policies/antiSpam"(controller: "policies",action: "antiSpam")
        "/policies/surveyContent"(controller: "policies",action: "surveyContent")
        "/policies/surveyTermsOfService"(controller: "policies",action: "surveyTermsOfService")
    }
}
