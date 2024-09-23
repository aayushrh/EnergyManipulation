extends Button

var changing = false
var prevA = ""
var action = ""

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and changing:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		print(event)
		print(InputMap.action_get_events(action))
		_not_changing()
		$HBoxContainer/Action.text = event.as_text() + " "
		prevA = $HBoxContainer/Action.text
		accept_event()

func _on_pressed():
	if(!changing):
		_is_changing()

func _is_changing():
	prevA = $HBoxContainer/Action.text
	$HBoxContainer/Action.text = "WAITING FOR INPUT..."
	changing = true

func _not_changing():
	if(prevA != ""):
		$HBoxContainer/Action.text = prevA
	changing = false
	
