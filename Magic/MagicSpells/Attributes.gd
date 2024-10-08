extends Node
class_name Attributes

var size
var power
var amount

func _init(siz, pow, amt):
	size = siz
	power = pow
	amount = amt

func getSize():
	return (size/100+1)/(0.1*amount+0.9)

func getASpeed():
	return (-size/100+1)/(0.05*amount+1)

func getPSpeed():
	return (-power/100+1)/(0.0263157894739*amount+0.9736842105261)

func getPower():
	return (power/100+1)/(0.3*amount+0.7)

func getAmount():
	return amount
