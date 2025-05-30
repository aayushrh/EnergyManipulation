extends Node
class_name AttributesWrapper

var attr : Attributes
var rightvalue : float
var leftvalue : float

func _init(att:Attributes) -> void:
	attr = att
	var ratio = (att.num - att.minL)/(att.maxL-att.minL)
	rightvalue = att.minR + ((1.0-ratio) * (att.maxR - att.minR))
	leftvalue = att.num
