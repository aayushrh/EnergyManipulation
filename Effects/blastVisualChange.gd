extends CPUParticles2D

func _process(delta):
	delta *= Global.getTimeScale()
	speed_scale = delta * 120
	if(Global.particlesNotShowing):
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false
