extends Node
class_name Attributes

var size
var power
var attack_speed
var projectile_speed
var amount
var supreme


func _init(siz, pow, stlh):
	size = siz/100+1
	attack_speed = (-size)/100+1
	power = pow/100+1
	projectile_speed = (-pow)/100+1
	amount = stlh/100+1
	supreme = (-stlh)/100+1


