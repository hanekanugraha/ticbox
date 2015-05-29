package ticbox

class Coupon {
	String code
	String description
	String metric /* P:Percentage, A:Amount*/
	Number amount
	String usable // Y:yes, N:no
	Number usableMax
	Number usableCount = 0

    static constraints = {
    }
}
