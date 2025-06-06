extends Node

var emitting = false
@export var vfxName : String
var time = 0
var baseScale : Vector2
var stack = 1.0
var maxStack = 20.0

func _init():
	self.modulate = Color(1,1,1,0.75*1/maxStack + 0.25)
	baseScale = self.scale

func _process(delta):
	delta *= Global.getTimeScale()
	self.modulate = Color(1,1,1,0.75*min(stack/maxStack,1) + 0.25)
	time += delta
	self.scale = baseScale * (3 * max(0, (maxStack-stack)/maxStack) + 1)
