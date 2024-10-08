extends Node2D
class_name SpellCard

var type = 0
var spellName = ""

func _init(typeI, nameI):
	type = typeI
	spellName = nameI
	if(!Constants.isValid(self)):
		push_error("Invalid Spell moment, fix pls")
