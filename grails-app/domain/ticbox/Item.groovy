package ticbox

class Item{

    static STATUS = [Active:"Active", Inactive:"Inactive"]

    String id
    String itemName
    String pic
    String status
    double gold

    static constraints = {
        itemName(nullable: false, blank: false)
        gold(nullable: false)
        status(nullable: false)
        pic(nullable: true)
    }
}
