extends Node2D

var selected = ""

func _change(num):
	$Category.text = selected
	$Category.position.x = 250 - $Category.size.x/2
	$ColorRect/Control/ScrollContainer/CardList.typeShowing = num

func _on_element_2_pressed():
	selected = "Element"
	_change(0)

func _on_symbol_2_pressed():
	selected = "Style"
	_change(1)

func _on_attribute_2_pressed():
	selected = "Attribute"
	_change(-1)

func _on_spell_type_pressed():
	selected = "Type"
	_change(2)
