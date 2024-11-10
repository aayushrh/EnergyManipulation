extends ColorRect

signal pressed(card)

var c = null

func _show(card):
	c = card
	$VBoxContainer/Label.text = card.spellName
	match(card.type):
		0:
			$VBoxContainer/Label2.text = "Element"
		1:
			$VBoxContainer/Label2.text = "Style"
		2:
			$VBoxContainer/Label2.text = "Type"

func _on_touch_screen_button_pressed():
	pressed.emit(c)
