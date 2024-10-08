extends ColorRect

var spell = null

func _initialize():
	$Label.text = spell.spellName
	$Label2.text = (char)(spell.binding)
