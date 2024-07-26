extends VBoxContainer

@onready var MagicButton = preload("res://World/UI/MagicCardButton.tscn")

var typeShowing = -1
var lastShowing = -1

func _process(delta):
	if(typeShowing != lastShowing):
		for i in get_children():
			i.queue_free()
		for i in Global.magicCards:
			if i.type == typeShowing:
				var button = MagicButton.instantiate()
				button.get_child(0).text = i.spellName
				add_child(button)
		lastShowing = typeShowing
