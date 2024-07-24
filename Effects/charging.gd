extends Node2D
class_name Card

@onready var circle = preload("res://Effects/ChargingParticle.tscn")
var vel = []
var rng = RandomNumberGenerator.new()
var emitting = false

func _process(delta):
	for i in range(0, 2):
		if emitting:
			var x = rng.randf_range(-1, 1)
			rng.randomize()
			var y = rng.randf_range(-1, 1)
			rng.randomize()
			var v = Vector2(x, y)
			v = v.normalized()
			var e = circle.instantiate()
			rng.randomize()
			e.position = v * rng.randf_range(-100, 100)
			e.v = -e.position.normalized()
			e.look_at(Vector2.ZERO)
			e.rotation_degrees += 90
			add_child(e)
		
	for i in get_children():
		if(pow(i.position.x, 2) + pow(i.position.y, 2) < 1000):
			i.queue_free()

