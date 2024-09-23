extends Button

var magicMenu = null
var spell = null

@export var nameText : Label

func _initialize():
	nameText.text = spell.spellName

func _on_pressed():
	magicMenu._changeSpell(spell)
