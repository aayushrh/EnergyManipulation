extends CPUParticles2D

@export var vfxName : String
var stack = 1.0
var maxStack = 20.0

func _process(delta: float) -> void:
	delta *= Global.getTimeScale()
	speed_scale = delta * 120
