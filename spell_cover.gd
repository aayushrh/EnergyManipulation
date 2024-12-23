extends Control

@onready var img = preload("res://StyleSpin.tscn")#change this to wherever you move it btw :3

@export var Title: Label
@export var MagicMenu: Control
@export var SpellList: VBoxContainer
#@export var Keybind: Button
var spell: Spell

var changing = false
var keybind = 0

func on_open():
	MagicMenu.dontLeave = true
	spell = MagicMenu.selectedSpell
	Title.text = spell.spellName
	if(!spell.type):
		return
	if(spell.element):
		$ColorRect.color = spell.element.color
	else:
		$ColorRect.color = Color(0.2,0.2,0.2)
	$Type.texture = spell.type.icon
	#for i in range(0,spell.): #change this after u make it so multi styles are supported lmao
	if(spell.style):
		var t = img.instantiate()
		t.changeIcon(spell.style.icon)
		t.changeColor(spell.style.color)
		t.perpV = 50000
		t.dist = 100
		t.center = global_position + Vector2(150,250)
		t.name = "help"
		add_child(t)

func _on_exit_pressed():
	if(spell.style):
		print("ATTEMPTED MURDER!!!! ON MY WATCH????")
		$help.kill()
	MagicMenu.dontLeave = false
	visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
