package ticbox

/**
 * Generated by the Shiro plugin. This filters class protects all URLs
 * via access control by convention.
 */
class SecurityFilters {

    def publicControllers = ["oauth","shiroOAuth","home","policies","userMessage","knowUs","howItsWork", "pricing"]

    def filters = {
        all(uri: "/**") {
            before = {
                // Ignore direct views (e.g. the default main index page).
                if (!controllerName) return true

                // Exclude the "public" controller.
                if (publicControllers.contains(controllerName)) return true

                // Access control by convention.
                accessControl()
            }
        }
    }
}
