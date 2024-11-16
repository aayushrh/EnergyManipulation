extends VBoxContainer

var adding = false

@export var textEdit : TextEdit
@export var magicMenu : Node2D

@onready var spell = preload("res://Magic/MagicSpells/SpellUI.tscn")

func _ready():
	reload()

func reload():
	for i in get_children():
		i.queue_free()
	for i in Global.spellList:
		if(i.binding != null):
			var box = spell.instantiate()
			box.spell = i
			box._initialize()
			add_child(box)
