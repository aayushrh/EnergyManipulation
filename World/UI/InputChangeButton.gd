extends Button

var changing = false
var prevA = ""

func _input(event):
	if event is InputEventKey and changing:
		var action = $HBoxContainer/Input.text
		for i in InputMap.action_get_events(action):
			InputMap.action_erase_event(action, i)
		InputMap.action_add_event(action, event)
		_not_changing()
		$HBoxContainer/Action.text = event.as_text() + " "
		prevA = $HBoxContainer/Action.text
	elif event is InputEventMouseButton:
		_not_changing()

func _on_pressed():
	if(!changing):
		_is_changing()
	else:
		_not_changing()

func _is_changing():
	prevA = $HBoxContainer/Action.text
	$HBoxContainer/Action.text = "WAITING FOR INPUT..."
	changing = true

func _not_changing():
	if(prevA != ""):
		$HBoxContainer/Action.text = prevA
	changing = false
	
