extends Button

var magicMenu = null
var spell = null
var changing = false
var changeToDontLeave = false

@export var nameText : Label

func _initialize():
	$HBoxContainer/Button.visible = true
	nameText.text = spell.spellName
	if(spell.binding == null):
		#$HBoxContainer/Button.text = "?"
		$HBoxContainer/Button/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_any.png")
	else:
		$HBoxContainer/Button/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_" + str(spell.binding) + ".png")
		#$HBoxContainer/Button.text = (char)(spell.binding)

func _on_pressed():
	magicMenu._changeSpell(spell)

func _on_button_pressed():
	magicMenu.dontLeave = true
	changing = true
	$HBoxContainer/Button.text = "..."
	
func _input(event):
	if changing and event is InputEventKey and event.pressed:
		Global.spellList.remove_at(Global.spellList.find(spell))
		spell.binding = event.keycode
		print("this is event keycode: " + str(event.keycode))
		#$HBoxContainer/Button.text = char(event.keycode)
		$HBoxContainer/Button/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_" + str(event.keycode) + ".png")
		Global.spellList.append(spell)
		changing = false
		$HBoxContainer/Button.visible = false
		$HBoxContainer/Button.visible = true
		changeToDontLeave = true

func _process(delta):
	if changeToDontLeave:
		magicMenu.dontLeave = false
		changeToDontLeave = false
