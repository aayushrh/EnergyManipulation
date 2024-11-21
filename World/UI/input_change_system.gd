extends Control

var exitShown = false

func _on_button_pressed():
	queue_free()

func _process(delta):
	if Input.is_action_just_pressed("Pause") and exitShown:
		_on_button_pressed()

func _exitShown():
	$Button.visible = true
	exitShown = true
