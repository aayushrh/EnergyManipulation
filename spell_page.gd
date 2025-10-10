extends Control
class_name SpellPage

signal noPageChange()

var card  = null
var spell: Spell
var gay: Array[Array] #Hboxcontainers
@onready var slider = preload("res://Slider.tscn")

var RED = Color(1, .2, .2)
var GREEN = Color(.2, 1, .2)
var GREY = Color(1, 1, 1)
var checks: Array[AttributesWrapper]
var pageNum := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_card(car):
	antihomo()
	if car != null:
		refresh()
		print(spell.attributes)
		print(pageNum)
		$ColorRect2._show(car)
		var counter = 0
		card = car
		for c in car.attribute:
			var check = checkAttributeExistence(c)
			if(!check):
				check = AttributesWrapper.new(c) #AttributesWrapper.new(c)
				spell.attributes[pageNum].append(check)
			checks.append(check)
			var slide = slider.instantiate()
			slide.value_changed.connect(updateVals)
			slide.nuhuh.connect(nuhuh)
			slide.init(check, counter)
			$ColorRect/VScrollBar/VBoxContainer.add_child(slide)
			cook(check)
			counter += 1
	else:
		$ColorRect3.visible = true

func refresh():
	print(len(spell.components))
	while(len(spell.attributes) < len(spell.components) + 1):
		spell.attributes.insert(pageNum, [])


func antihomo():
	for i in $ColorRect/VScrollBar/VBoxContainer.get_children():
		i.queue_free()
	gay = []
	checks = []

func checkAttributeExistence(attribute):
	for t in spell.attributes[pageNum]:
		if(t.attr == attribute):
			return t
	return null

func cook(dic: AttributesWrapper):
	var arr = []
	for key in dic.d:
		var hbox = HBoxContainer.new()
		var lab1 = Label.new()
		var lab2 = Label.new()
		lab1.add_theme_font_override("font", load("res://Art/KodeMono-Regular.ttf"))
		lab2.add_theme_font_override("font", load("res://Art/KodeMono-Regular.ttf"))
		lab1.horizontal_alignment = 0
		lab1.text = dic.d[key]["alias"]
		lab2.horizontal_alignment = 2
		lab2.text = dic.getValueString(key)
		lab2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lab1.set("theme_override_colors/font_color", dic.getColor(key))
		lab2.set("theme_override_colors/font_color", dic.getColor(key))
		hbox.add_child(lab1)
		hbox.add_child(lab2)
		arr.append(hbox)
		$ColorRect/VScrollBar/VBoxContainer.add_child(hbox)
	gay.append(arr)

func change(num):
	if(num >= 0):
		pageNum = num
		visible = true
		show_card(spell.type if num == 0 else spell.components[num - 1])

func updateVals(val : float, at : int):
	var num = at*2
	if(checks[at]._updateValue(val)):
		var i = 0
		for key in checks[at].d:
			gay[at][i].get_child(0).set("theme_override_colors/font_color", checks[at].getColor(key))
			gay[at][i].get_child(1).set("theme_override_colors/font_color", checks[at].getColor(key))
			gay[at][i].get_child(1).text = checks[at].getValueString(key)
			i += 1
		get_parent().updateAttr(val, card.attribute[at])

func nuhuh():
	noPageChange.emit()
