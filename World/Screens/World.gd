extends Node2D

func _process(delta):
	if(Input.is_action_just_pressed("Pause") and Global.pause):
		Global.pause = false
		$CanvasLayer/InputOptions.visible = false
	elif(Input.is_action_just_pressed("Pause") and !Global.pause):
		print(Global.pause)
		Global.pause = true
		$CanvasLayer/InputOptions.visible = true
