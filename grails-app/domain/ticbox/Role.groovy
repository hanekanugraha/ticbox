package ticbox

class Role {

    static ROLE= [RESPONDENT:"Respondent", SURVEYOR:"Surveyor",ADMIN:"Admin"]

    String id
    String name
    static hasMany = [ users: User, permissions: String ]
    static belongsTo = User

    static constraints = {
        name(nullable: false, blank: false, unique: true)
    }
}
