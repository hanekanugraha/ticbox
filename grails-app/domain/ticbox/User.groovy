package ticbox

class User {
    String username
    String passwordHash
    String email
    String pic
    String verify
    String verifyCode
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
        verifyCode(nullable: false)
    }
    static mapping = {
        username index: true
    }
}

