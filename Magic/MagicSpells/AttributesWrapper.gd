extends Node
class_name AttributesWrapper

var attr : Attributes
var rightvalue : float
var leftvalue : float

func _init(att):
	attr = att
	rightvalue = -att.num + 50
	leftvalue = att.num + 50
