extends StaticBody2D
class_name Wall

var type : int = 3
var health : float = 0
var blocking : bool = false

func _hit(_other : SpellCasted) -> void:
	pass

func attachEffect(_effect : Effects) -> void:
	pass
