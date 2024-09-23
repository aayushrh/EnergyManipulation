extends Node2D

var lifetime = 20

func _process(delta):
	lifetime -= 1
	if(lifetime <=0):
		queue_free()
