extends Control

signal change_page(val)
var gay: Array[HBoxContainer]
var spell: Spell


@onready var TBFTOC = preload("res://TextButtonForTableOfContents.tscn")

@export var SPage : SpellPage

func exist():
	if(spell.type):
		cook(spell.type.cardName, 1)
	else:
		cook("Typeless", 1)
		
	for s in spell.element.size():
		cook(spell.element[s].cardName, s + 2)
	for s in spell.style.size():
		cook(spell.style[s].cardName, s + spell.element.size() + 2)
	
	


func cook(txt, val):
	var thing = TBFTOC.instantiate()
	thing.change_button.connect(change_button)
	thing.init(txt, val)
	$ColorRect/VScrollBar/VBoxContainer.add_child(thing)

func change_button(val):
	change_page.emit(val)

func _on_exit_pressed():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
