extends VBoxContainer

@onready var InputButton = preload("res://World/UI/InputChangeButton.tscn")

var list = {
	"UP" : "up",
	"LEFT" : "left",
	"DOWN" : "down",
	"RIGHT" : "right",
	"PUNCH/ATTACK" : "Hit",
	"BLOCK" : "Block",
	"DASH" : "Dash",
	"ABILITY 1" : "Ability1",
	"ABILITY 2" : "Ability2",
	"ABILITY 3" : "Ability3",
}

func _ready():
	for i in list:
		var inputButton = InputButton.instantiate()
		var inputLabel = inputButton.find_child("Input")
		var actionLabel = inputButton.find_child("Action")
		inputLabel.text = i
		if(InputMap.action_get_events(list[i]).size() > 0):
			actionLabel.text = InputMap.action_get_events(list[i])[0].as_text().trim_suffix("(Physical)")
		add_child(inputButton)
