extends ColorRect

signal pressed(card)

var c = null

func _show(card):
	c = card
	var c = card.color
	c.a = 0.5
	$ColorRect.color = c
	if((c.r + c.b + c.g)/3.0 > 0.75):
		$VBoxContainer/Label.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label2.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label3.add_theme_color_override("font_color", Color.BLACK)
	$TextureRect.texture = card.icon
	$VBoxContainer/Label.text = card.cardName
	$VBoxContainer/Label3.text = card.cardDescription
	match(card.type):
		0:
			$VBoxContainer/Label2.text = "Element"
		1:
			$VBoxContainer/Label2.text = "Style"
		2:
			$VBoxContainer/Label2.text = "Type"

func _on_touch_screen_button_pressed():
	pressed.emit(c)
