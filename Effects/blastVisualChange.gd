extends CPUParticles2D

func _process(delta):
	speed_scale = Global.getTimeScale()
	if(Global.particlesNotShowing):
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false
