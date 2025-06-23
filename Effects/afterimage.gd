extends Node

@export var lifetime : int = 20

func _process(delta : float) -> void:
	lifetime -= 1
	if(lifetime <=0):
		queue_free()
