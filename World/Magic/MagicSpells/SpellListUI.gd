extends VBoxContainer

var adding = false

@export var textEdit : TextEdit
@export var magicMenu : Node2D

@onready var spell = preload("res://World/Magic/MagicSpells/SpellUI.tscn")

func _ready():
	test()
	reload()

func test():
	for i in range(0, 10):
		var namem = "e" + str(i)
		var spell = Spell.new(namem)
		spell.binding = 64
		Global.spellList.append(spell)

func reload():
	for i in get_children():
		i.queue_free()
	for i in Global.spellList:
		if(i.binding != null):
			var box = spell.instantiate()
			box.spell = i
			box._initialize()
			add_child(box)
