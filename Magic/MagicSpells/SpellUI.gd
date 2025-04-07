extends ColorRect

var spell = null
var initSize = 0

func _initialize():
	$Label.text = spell.spellName
	$Label2/TextureRect.texture = load("res://Art/KeyboardIcons/keyboard_" + str(spell.binding) + ".png")
	#$Label2.text = (char)(spell.binding)

func _process(delta):
	if(spell != null):
		if initSize == 0:
			initSize = $ColorRect2.size.x
			$ColorRect2.size.x = 0
		$ColorRect2.size.x = (spell.cooldown/spell.getcd()) * initSize
	#print(spell.cooldown)
