extends Control

signal change_button(val)
var selectColor = Color(0.6, 0.6, 0.6)

func init(text, val):
	$HBoxContainer/Label.text = text
	$HBoxContainer/Label2.text = str(val)



func _on_button_pressed() -> void:
	change_button.emit(int($HBoxContainer/Label2.text))


func _on_button_mouse_entered() -> void:
	$HBoxContainer/Label.set("theme_override_colors/font_color", selectColor)
	$HBoxContainer/Label2.set("theme_override_colors/font_color", selectColor)


func _on_button_mouse_exited() -> void:
	$HBoxContainer/Label.set("theme_override_colors/font_color", Color(1, 1, 1))
	$HBoxContainer/Label2.set("theme_override_colors/font_color", Color(1, 1, 1))
