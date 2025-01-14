extends Control

var card = null
var page = 0
var spell: Spell
@onready var slider = preload("res://Slider.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_card(car):
	$ColorRect2._show(car)
	for c in car.attribute:
		var slide = slider.instantiate()
		slide.attr = c
		$HSlider.add_child(slide.attr)
	

func change(num):
	visible = true
	if(page == num):
		card = spell.type
		show_card(card)
	else:
		visible = false
		
