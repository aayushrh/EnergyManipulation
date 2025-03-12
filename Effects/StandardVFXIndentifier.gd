extends Node

var emitting = false
@export var vfxName : String
var time = 0
var baseScale : Vector2

func _init():
	self.modulate = Color(1,1,1,1)
	baseScale = self.scale

func _process(delta):
	time += delta
	self.scale = baseScale * (2 + sin(time * PI))
