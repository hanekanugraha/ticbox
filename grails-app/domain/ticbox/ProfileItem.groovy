package ticbox

class ProfileItem {

    static TYPES = [
        STRING : 'STRING',    //may have placeHolder(String), row(int), max(int)
        NUMBER : 'NUMBER',    //will have unit(String)
        DATE   : 'DATE',      //will have
        LOOKUP : 'LOOKUP',    //will have lookUpFrom(LookupMaster.code)
        CHOICE : 'CHOICE'     //will have either items(List) or lookUpFrom(LookupMaster.code), will have componentType(ProfileItem.COMPONENT_TYPES), may have multiple(boolean)

    ]

    static COMPONENT_TYPES = [
        CHK_BOX : 'CHK_BOX',
        SELECT : 'SELECT',
        RADIO : 'RADIO'
    ]

    String id
    String code
    String label
    String type
    int seq = 0

    static constraints = {
    }
}
