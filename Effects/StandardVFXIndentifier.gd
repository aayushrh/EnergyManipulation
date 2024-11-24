extends Node

var emitting = false
@export var vfxName : String
var time = 0

func _process(delta):
	time += delta
	#if time < 0.5:
		#get_child(4).scale.x = lerp(2.0, 1.0, time/0.5)
		#get_child(4).scale.y = lerp(2.0, 1.0, time/0.5)
	#else:
		#get_child(4).scale.x = lerp(1.0, 2.0, time)
		#get_child(4).scale.y = lerp(1.0, 2.0, time)
