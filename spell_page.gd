extends Control
class_name SpellPage

signal noPageChange()

var card  = null
var spell: Spell
var gay: Array[HBoxContainer]
@onready var slider = preload("res://Slider.tscn")

var RED = Color(1, .2, .2)
var GREEN = Color(.2, 1, .2)
var GREY = Color(1, 1, 1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_card(car):
	antihomo()
	$ColorRect2._show(car)
	var counter = 0
	for c in car.attribute:
		var check = checkAttributeExistence(c)
		if(!check):
			check = AttributesWrapper.new(c)
			spell.attributes.append(check)
		cook(check.attr.Ltext,check.leftvalue / (check.attr.num - check.attr.min) * 100)
		cook(check.attr.Rtext,check.rightvalue / (check.attr.num + check.attr.max) * 100)
		var slide = slider.instantiate()
		slide.value_changed.connect(diffNum)
		slide.nuhuh.connect(nuhuh)
		slide.num = counter
		slide.init(check)
		$ColorRect/VScrollBar/VBoxContainer.add_child(slide)
		
		counter += 1
	for g in gay:
		$ColorRect/VScrollBar/VBoxContainer.add_child(g)

func antihomo():
	for i in $ColorRect/VScrollBar/VBoxContainer.get_children():
		i.queue_free()
	gay = []

func checkAttributeExistence(attribute):
	for s in spell.attributes:
		if(s.attr == attribute):
			return s
	return null

func cook(txt, val):
	var hbox = HBoxContainer.new()
	var lab1 = Label.new()
	var lab2 = Label.new()
	lab1.add_theme_font_override("font", load("res://Art/KodeMono-Regular.ttf"))
	lab2.add_theme_font_override("font", load("res://Art/KodeMono-Regular.ttf"))
	lab1.horizontal_alignment = 0
	lab1.text = txt
	lab2.horizontal_alignment = 2
	lab2.text = str(val) + "%"
	lab2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(lab1)
	hbox.add_child(lab2)
	gay.append(hbox)

func change(num):
	visible = true
	if(num == 0):
		card = spell.type
	elif(num <= spell.element.size()):
		card = spell.element[num-1]
	elif(num <= spell.element.size() + spell.style.size()):
		card = spell.style[num-1-spell.element.size()]
	show_card(card)

func gradient(c1: Color, c2: Color, blend: float):
	var c = c1
	c += (c2-c1)*blend
	return c

func diffNum(lval, rval, bval, grad, at):
	
	var num = at*2
	if(lval>bval):
		gay[num + 1].get_child(0).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
		gay[num + 1].get_child(1).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
		gay[num].get_child(0).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
		gay[num].get_child(1).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
	elif(lval == bval):
		gay[num].get_child(0).set("theme_override_colors/font_color", GREY)
		gay[num].get_child(1).set("theme_override_colors/font_color", GREY)
		gay[num + 1].get_child(0).set("theme_override_colors/font_color", GREY)
		gay[num + 1].get_child(1).set("theme_override_colors/font_color", GREY)
	else:
		gay[num + 1].get_child(0).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
		gay[num + 1].get_child(1).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
		gay[num].get_child(0).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
		gay[num].get_child(1).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
	gay[num].get_child(1).text = str(lval) + "%"
	gay[num + 1].get_child(1).text = str(rval) + "%"

func nuhuh():
	noPageChange.emit()
