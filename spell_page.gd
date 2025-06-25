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
	if car != null:
		$ColorRect2._show(car)
		var counter = 0
		card = car
		for c in car.attribute:
			var check = checkAttributeExistence(c)
			if(!check):
				check = AttributesWrapper.new(c)
				spell.attributes.append(check)
			cook(check.attr.Ltext,check.leftvalue + check.attr.addL, check.attr.percentL)
			cook(check.attr.Rtext,check.rightvalue + check.attr.addR, check.attr.percentR)
			var slide = slider.instantiate()
			slide.value_changed.connect(updateVals)
			slide.nuhuh.connect(nuhuh)
			slide.num = counter
			slide.init(check)
			$ColorRect/VScrollBar/VBoxContainer.add_child(slide)
			
			counter += 1
		for g in gay:
			$ColorRect/VScrollBar/VBoxContainer.add_child(g)
	else:
		$ColorRect3.visible = true

func antihomo():
	for i in $ColorRect/VScrollBar/VBoxContainer.get_children():
		i.queue_free()
	gay = []

func checkAttributeExistence(attribute):
	for s in spell.attributes:
		if(s.attr == attribute):
			return s
	return null

func cook(txt, val, percent):
	var hbox = HBoxContainer.new()
	var lab1 = Label.new()
	var lab2 = Label.new()
	lab1.add_theme_font_override("font", load("res://Art/KodeMono-Regular.ttf"))
	lab2.add_theme_font_override("font", load("res://Art/KodeMono-Regular.ttf"))
	lab1.horizontal_alignment = 0
	lab1.text = txt
	lab2.horizontal_alignment = 2
	if percent:
		lab2.text = str(val) + "%"
	else:
		lab2.text = str(val)
	lab2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(lab1)
	hbox.add_child(lab2)
	gay.append(hbox)

func change(num):
	if(num >= 0):
		visible = true
		if(num == 0):
			card = spell.type
		else:
			card = spell.components[num-1]
		show_card(card)

func gradient(c1: Color, c2: Color, blend: float):
	var c = c1
	c += (c2-c1)*blend
	return c

func updateVals(lval, rval, at):
	var num = at*2
	
	if(lval > card.attribute[at].num):
		var grad = (lval - card.attribute[at].num)/(card.attribute[at].maxL - card.attribute[at].num)
		gay[num + 1].get_child(0).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
		gay[num + 1].get_child(1).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
		gay[num].get_child(0).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
		gay[num].get_child(1).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
	elif(lval == card.attribute[at].num):
		gay[num].get_child(0).set("theme_override_colors/font_color", GREY)
		gay[num].get_child(1).set("theme_override_colors/font_color", GREY)
		gay[num + 1].get_child(0).set("theme_override_colors/font_color", GREY)
		gay[num + 1].get_child(1).set("theme_override_colors/font_color", GREY)
	else:
		var grad = (card.attribute[at].num - lval)/(card.attribute[at].num - card.attribute[at].minL)
		gay[num + 1].get_child(0).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
		gay[num + 1].get_child(1).set("theme_override_colors/font_color", gradient(GREY, GREEN, grad))
		gay[num].get_child(0).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
		gay[num].get_child(1).set("theme_override_colors/font_color", gradient(GREY, RED, grad))
	
	if(card.attribute[at].percentL):
		gay[num].get_child(1).text = str(lval + card.attribute[at].addL) + "%"
	else:
		gay[num].get_child(1).text = str(lval + card.attribute[at].addL)
	if(card.attribute[at].percentR):
		gay[num + 1].get_child(1).text = str(rval + card.attribute[at].addR) + "%"
	else:
		gay[num + 1].get_child(1).text = str(rval + card.attribute[at].addR)
	get_parent().updateAttr(lval, rval, card.attribute[at])

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
	
	get_parent().updateAttr(lval, rval, card.attribute[at])

func nuhuh():
	noPageChange.emit()
