extends VBoxContainer

@onready var MagicButton = preload("res://World/Magic/MagicCards/MagicCardButton.tscn")

@export var magicMenu : Control
		
func _reload(typeShow):
	for i in get_children():
		i.queue_free()
	for i in Global.magicCards:
		if i.type == typeShow:
			var button = MagicButton.instantiate()
			button.get_child(0).text = i.spellName
			button.card = i
			button.magicMenu = magicMenu
			add_child(button)
