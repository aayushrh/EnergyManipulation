extends Node
class_name Attributes

var size = 0.0
var power = 0.0
var amount = 1

func _init(siz, pow, amt):
	size = siz
	power = pow
	amount = amt

func getSize():
	return (size/100+1)/(0.05*amount+0.95)

func getASpeed():
	return (-size/100+1)/(0.05*amount+0.95)

func getPSpeed():
	return (-power/100+1)/(0.0263157894739*amount+0.9736842105261)

func getPower():
	return (power/100+1)/(0.3*amount+0.7)

func getAmount():
	return amount
