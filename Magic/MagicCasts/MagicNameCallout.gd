extends Node2D

@export var lifetime = 0.25

func _process(delta):
	delta *= Global.getTimeScale()
	lifetime -= delta
	if(lifetime < 0):
		queue_free()

func _show(spell):
	$RichTextLabel.text = "[b]" + spell.spellName + "!![/b]"
	#$RichTextLabel.position.x = -2*$RichTextLabel.size.x/8
	#if(spell.element != null):
		#$RichTextLabel.add_theme_color_override("default_color", Color.WHITE)
		#if(spell.element.spellName.to_lower() == "fire"):
			#$RichTextLabel.add_theme_color_override("default_color", Color.RED)
		#if(spell.element.spellName.to_lower() == "water"):
			#$RichTextLabel.add_theme_color_override("default_color", Color.ROYAL_BLUE)
	#else:
		#$RichTextLabel.add_theme_color_override("default_color", Color.WHITE)
