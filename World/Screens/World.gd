extends Node2D

func _process(delta):
	if(Input.is_action_just_pressed("Pause") and Global.pause):
		Global.pause = false
		$CanvasLayer/InputChangeSystem.visible = false
	elif(Input.is_action_just_pressed("Pause") and !Global.pause):
		Global.pause = true
		$CanvasLayer/InputChangeSystem.visible = true
