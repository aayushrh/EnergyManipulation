extends VBoxContainer
class_name CardList

@onready var MagicButton = preload("res://Magic/MagicCards/MagicCardButton.tscn")

@export var magicMenu : Control
		
func _reload(typeShow):
	for i in get_children():
		i.queue_free()
	for i in Global.magicCards:
		if i != null and i.type == typeShow:
			var button = MagicButton.instantiate()
			button.text = i.cardName
			button.icon = i.icon
			button.modulate = i.color
			#button.get_child(0).text = i.cardName
			button.card = i
			button.magicMenu = magicMenu
			add_child(button)
