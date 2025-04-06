extends Button

var changing = false
var prevA = ""
var action = ""
var currentShown = -1

func _input(event):
	if (event is InputEventKey) and changing:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		print(event)
		print(InputMap.action_get_events(action))
		_not_changing()
		$HBoxContainer/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_" + str(event.keycode) + ".png")
		currentShown = event.keycode
		#prevA = $HBoxContainer/Action.text
		accept_event()

func _on_pressed():
	if(!changing):
		_is_changing()

func _is_changing():
	#prevA = $HBoxContainer/Action.text
	$HBoxContainer/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_" + str(currentShown) + ".png")
	#$HBoxContainer/Action.text = "WAITING FOR INPUT..."
	changing = true

func _not_changing():
	if(currentShown != -1):
		$HBoxContainer/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_" + str(currentShown) + ".png")
		#$HBoxContainer/Action.text = prevA
	changing = false
	
