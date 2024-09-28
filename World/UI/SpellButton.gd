extends Button

var magicMenu = null
var spell = null
var changing = false

@export var nameText : Label

func _initialize():
	nameText.text = spell.spellName
	$HBoxContainer/Button.text = "?"

func _on_pressed():
	magicMenu._changeSpell(spell)

func _on_button_pressed():
	changing = true
	$HBoxContainer/Button.text = "..."
	
func _input(event):
	if changing and event is InputEventKey and event.pressed:
		Global.spellList.remove_at(Global.spellList.find(spell))
		spell.binding = event.keycode
		$HBoxContainer/Button.text = char(event.keycode)
		Global.spellList.append(spell)
		changing = false
