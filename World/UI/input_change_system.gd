extends Control

func _on_button_pressed():
	queue_free()

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		_on_button_pressed()
