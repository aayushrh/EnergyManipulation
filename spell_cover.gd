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
var colordelay = 0.0
var MAXCOLORDELAY = 2.0

func on_open():
	visible = true
	colorindex = 1
	colorval = 0.0
	colordelay = MAXCOLORDELAY
	for s in things:
		s.queue_free()
	#for a in elements:
	#	a.queue_free()
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
	$Type.texture = spell.type.icon
	if(spell.components):
		var n = 0
		for s in spell.components:
			if(s.isElement):
				elements.append(s);
			else:
				var t = img.instantiate()
				t.num = n
				n += 1
				t.changeIcon(s.icon)
				t.changeColor(s.color)
				#t.amt = spell.components.size()
				t.perpV = 50000
				t.dist = 100
				t.center = global_position + Vector2(150, 250)
				things.append(t)
				add_child(t)
		for s in things:
			s.amt = things.size()
	if(elements.size()>0):
		colorstrat_2()

func _on_exit_pressed():
	for s in things:
		s.queue_free()
	things = []
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
	if(visible):
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
	$ColorRect.color = elements[0].color

func colorchange(delta):
	if elements.size() > 0:
		if(colordelay >= 0):
			colordelay -= delta
		else:
			var cv = colorindex - 1
			if(cv < 0):
				cv = elements.size() - 1
			if(colorval == 0):
				$ColorRect.color = elements[cv].color
			else:
				$ColorRect.color = elements[cv].color + (elements[colorindex].color-elements[cv].color) * colorval
			colorval += delta * 0.5
			if(colorval >= 1.0):
				colordelay = MAXCOLORDELAY
				colorval = 0
				colorindex = (colorindex + 1) % elements.size()
	else:
		$ColorRect.color = Color(0.4, 0.4, 0.4)
