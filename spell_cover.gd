extends Control

@onready var img = preload("res://StyleSpin.tscn")#change this to wherever you move it btw :3

@export var Title: Label
@export var MagicMenu: Control
@export var SpellList: VBoxContainer
#@export var Keybind: Button
var spell: Spell

var changing = false
var keybind = 0

var styl = []

func on_open():
	visible = true
	for s in styl:
		s.queue_free()
	styl = []
	MagicMenu.dontLeave = true
	#spell = Global.spellList[0]
	spell = MagicMenu.selectedSpell
	if(!spell):
		return
	if(!spell.type):
		return
	if(spell.spellName):
		Title.text = spell.spellName
	else:
		Title.text = "Unnamed Spell"
	if(spell.element):
		var r = 0.0
		var g = 0.0
		var b = 0.0
		for e in spell.element:
			r += e.color.r
			g += e.color.g
			b += e.color.b
		$ColorRect.color = Color(r/spell.element.size(),g/spell.element.size(),b/spell.element.size())
	else:
		$ColorRect.color = Color(0.2,0.2,0.2)
	$Type.texture = spell.type.icon
	#for i in range(0,spell.): #change this after u make it so multi styles are supported lmao
	if(spell.style):
		var n = 0
		for s in spell.style:
			var t = img.instantiate()
			t.num = n
			n += 1
			t.changeIcon(s.icon)
			t.changeColor(s.color)
			t.amt = spell.style.size()
			t.perpV = 50000
			t.dist = 100
			t.center = global_position + Vector2(150, 250)
			styl.append(t)
			add_child(t)

func _on_exit_pressed():
	for s in styl:
		s.queue_free()
	styl = []
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
