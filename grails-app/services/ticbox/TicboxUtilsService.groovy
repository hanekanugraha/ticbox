package ticbox

import org.apache.shiro.SecurityUtils

class TicboxUtilsService {

    def transaction = false

    def serviceMethod() {

    }

    def getPrincipal(){
        SecurityUtils.subject.principal
    }
}
