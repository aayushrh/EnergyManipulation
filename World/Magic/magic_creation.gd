extends Node2D

var selected = ""
var selectedSpell = null

@export var element : Button
@export var type : Button
@export var style : Button
@export var cardList : VBoxContainer

func _changeSpell(nspell):
	$Control.visible = true
	selectedSpell = nspell
	ifNullDefault("Element", element, nspell.element)
	ifNullDefault("Style", style, nspell.style)
	ifNullDefault("Type", type, nspell.type)
	$Control/CurrentSpell.text = selectedSpell.spellName

func ifNullDefault(default, change, check):
	if(check != null):
		change.text = check.spellName
	else:
		change.text = default

func _inputCard(card):
	if selectedSpell != null:
		if (card.type == 0 and selectedSpell.element == null) or (card.type == 1 and selectedSpell.style == null) or (card.type == 2 and selectedSpell.type == null):
			var location = Global.spellList.find(selectedSpell)
			Global.magicCards.remove_at(Global.magicCards.find(card))
			Global.spellList.remove_at(location)
			match card.type:
				0:
					selectedSpell.element = card
				1:
					selectedSpell.style = card
				2:
					selectedSpell.type = card
			Global.spellList.insert(location, selectedSpell)
			cardList._reload(card.type)
		_changeSpell(selectedSpell)
		

func _change(num):
	$Category.text = selected
	cardList._reload(num)

func reset(nselected, changing, type):
	selected = nselected
	if(changing != null):
		Global.magicCards.append(changing)
		_changeSpell(selectedSpell)
		return true
	_change(type)
	return false

func control_invisible():
	$Control.visible=false

func _on_element_2_pressed():
	if(reset("Element", selectedSpell.element, 0)):
		selectedSpell.element = null
		_changeSpell(selectedSpell)
		_change(0)

func _on_symbol_2_pressed():
	if(reset("Style", selectedSpell.style, 1)):
		selectedSpell.style = null
		_changeSpell(selectedSpell)
		_change(1)

func _on_attribute_2_pressed():
	selected = "Attribute"
	_change(-1)

func _on_spell_type_pressed():
	if(reset("Type", selectedSpell.type, 2)):
		selectedSpell.type = null
		_changeSpell(selectedSpell)
		_change(2)


func _on_button_pressed():
	$MagicSettings.visible = true
	$MagicSettings.on_open()
