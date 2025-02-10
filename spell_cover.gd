extends Control

@onready var img = preload("res://StyleSpin.tscn")#change this to wherever you move it btw :3

@export var Title: Label
@export var MagicMenu: Control
@export var SpellList: VBoxContainer
#@export var Keybind: Button
var spell: Spell

var changing = false
var keybind = 0

var things = []
var elements = []
var colorval = 0.0
var colorindex = 0

func on_open():
	visible = true
	colorindex = 0
	colorval = 0.0
	for s in things:
		s.queue_free()
	for a in elements:
		a.queue_free()
	elements = []
	things = []
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
		colorstrat_2()
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
			things.append(t)
			add_child(t)

func _on_exit_pressed():
	for s in things:
		s.queue_free()
	things = []
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
	if(spell):
		colorchange(delta)

func colorstrat_1():
	var i = spell.element.size()
	for e in spell.element:
		var progress = TextureProgressBar.new()
		progress.fill_mode = 5
		progress.texture_progress = preload("res://Art/whiteSquare.webp")
		progress.scale = Vector2(300.0/256, 500.0/256)
		progress.self_modulate = e.color
		progress.max_value = spell.element.size() * 100
		progress.value = i * 100
		i -= 1
		$ColorRect.add_child(progress)
		elements.append(progress)

func colorstrat_2():
	$ColorRect.color = spell.element[0].color

func colorchange(delta):
	if spell.element.size() > 0 and visible:
		var cv = colorindex - 1
		if(cv < 0):
			cv = spell.element.size() - 1
		if(colorval == 0):
			$ColorRect.color = spell.element[cv].color
		else:
			$ColorRect.color = spell.element[cv].color + (spell.element[colorindex].color-spell.element[cv].color) * colorval
		colorval += delta * 0.5
		if(colorval >= 1.0):
			colorval = 0
			colorindex = (colorindex + 1) % spell.element.size()
	else:
		$ColorRect.color = Color(0.2, 0.2, 0.2)
