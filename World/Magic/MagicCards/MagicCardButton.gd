extends Button

var magicMenu = null
var card = null

func _on_pressed():
	magicMenu._inputCard(card)
