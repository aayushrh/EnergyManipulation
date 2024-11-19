extends Node2D
class_name SpellCard

var type = 0
var spellName = ""
var spellDesc = ""

func _init(typeI, nameI, spellDescI=""):
	type = typeI
	spellName = nameI
	if(!Constants.isValid(self)):
		push_error("Invalid Spell moment, fix pls")
	spellDesc = spellDescI
