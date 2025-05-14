extends CPUParticles2D

@export var vfxName : String

func _process(delta: float) -> void:
	delta *= Global.getTimeScale()
	speed_scale = delta * 120
