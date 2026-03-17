extends Camera2D

func _process(delta):
	if (Input.is_action_just_pressed("NoMouse")):
		$AnimationPlayer.play("Move")
