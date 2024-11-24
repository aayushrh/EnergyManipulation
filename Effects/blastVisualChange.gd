extends CPUParticles2D

func _process(delta):
	if(Global.particlesNotShowing):
		$Sprite2D.visible = true
	else:
		$Sprite2D.visible = false
