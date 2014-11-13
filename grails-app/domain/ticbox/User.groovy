package ticbox

class User {

    static USER_STATUS= [ENABLE:"1", DISABLE:"0"]

    String username
    String passwordHash
    String email
    String pic
    String verify
    String verifyCode
    String status
    String resetPassword
    RespondentProfile respondentProfile
    static embedded = ["respondentProfile"]
    static hasMany = [ roles: Role ]
    static constraints = {
        username(nullable: false, blank: false, unique: true)
        passwordHash(nullable: false)
        email(nullable: true, unique: true)
        pic(nullable: true)
        respondentProfile(nullable: true)
        verify(nullable: false)
        verifyCode(nullable: true)
        status(nullable: false)
        resetPassword(null:true)
    }
    static mapping = {
        username index: true
    }

    public static String getStatusLabel(String statusCode){
        if(statusCode.equals("1"))
            return "common.label.enable"
        else if(statusCode.equals("0"))
            return "common.label.disable"
        else return "common.label.unknown"
    }
}

