extends VBoxContainer

var adding = false

@export var textEdit : TextEdit
@export var magicMenu : Node2D

@onready var spellButton = preload("res://World/UI/SpellButton.tscn")

func _ready():
	reload()

func _on_add_button_pressed():
	adding = true
	textEdit.visible = true
	textEdit.grab_focus()
	var button = spellButton.instantiate()
	add_child(button)
	move_child(button, 0)
	#Global.spellList.append()

func _process(delta):
	if(adding and Input.is_action_just_pressed("enter")):
		var nname = textEdit.text
		var found = false
		for i in Global.spellList:
			if(nname == i.spellName):
				found = true
		if !found and nname.length() < 15:
			Global.spellList.append(Spell.new(nname))
			textEdit.visible = false
			textEdit.text = ""
			reload()
		else:
			textEdit.text = ""

func reload():
	for i in get_children():
		if(i.name != "AddButton"):
			i.queue_free()
	for i in Global.spellList:
		var button = spellButton.instantiate()
		#button.get_child(0).text = i.spellName
		button.magicMenu = magicMenu
		button.spell = i
		button._initialize()
		add_child(button)
		move_child(button, 0)
