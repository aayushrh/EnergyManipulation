extends Node2D

@export var lifetime = 0.25

func _process(delta):
	lifetime -= delta
	if(lifetime < 0):
		queue_free()

func _show(spell):
	$RichTextLabel.text = "[b]" + spell.spellName + "!![/b]"
	$RichTextLabel.position.x = -1*$RichTextLabel.size.x/4
	if(spell.element != null):
		if(spell.element.spellName.to_lower() == "fire"):
			$RichTextLabel.add_theme_color_override("default_color", Color.RED)
		if(spell.element.spellName.to_lower() == "water"):
			$RichTextLabel.add_theme_color_override("default_color", Color.ROYAL_BLUE)
	else:
		$RichTextLabel.add_theme_color_override("default_color", Color.WHITE)
