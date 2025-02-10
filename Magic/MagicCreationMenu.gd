extends Control

var selected = ""
var selectedSpell = null
var dontLeave = false

@export var element : Button
@export var type : Button
@export var style : Button
@export var cardList : VBoxContainer

func _changeSpell(nspell):
	#$Control.visible = true
	selectedSpell = nspell
	$Control/CurrentSpell.text = selectedSpell.spellName
	$SpellCreation.reset()

func addCard(type):
	_change(type)
	position.x = 350

func _finish():
	position.x = 0

func _inputCard(card):
	if selectedSpell != null:
		var location = Global.spellList.find(selectedSpell)
		Global.magicCards.remove_at(Global.magicCards.find(card))
		Global.spellList.remove_at(location)
		match card.type:
			0:
				selectedSpell.components.insert($SpellCreation.getCurrentPage(), card)
			2:
				selectedSpell.type = card
		Global.spellList.insert(location, selectedSpell)
		cardList._reload(card.type)
		$SpellCreation.reload(true)
		
		"""if (card is ElementSpellCard and selectedSpell.element == null) or (card is StyleSpellCard and selectedSpell.style == null) or (card is TypeSpellCard and selectedSpell.type == null):
			var location = Global.spellList.find(selectedSpell)
			Global.magicCards.remove_at(Global.magicCards.find(card))
			Global.spellList.remove_at(location)
			match card.type:
				0:
					selectedSpell.element.insert($SpellCreation.getCurrentPage(), card)
				1:
					selectedSpell.style.insert($SpellCreation.getCurrentPage(), card)
				2:
					selectedSpell.type = card
			Global.spellList.insert(location, selectedSpell)
			cardList._reload(card.type)
			$SpellSelection.reload()
		else:
			var location = Global.spellList.find(selectedSpell)
			Global.magicCards.remove_at(Global.magicCards.find(card))
			Global.spellList.remove_at(location)
			match card.type:
				0:
					Global.magicCards.append(selectedSpell.element)
					selectedSpell.element = card
				1:
					Global.magicCards.append(selectedSpell.style)
					selectedSpell.style = card
				2:
					Global.magicCards.append(selectedSpell.type)
					selectedSpell.type = card
			Global.spellList.insert(location, selectedSpell)
			cardList._reload(card.type)
		_changeSpell(selectedSpell)
		"""

func _change(num):
	match num:
		0:
			$Category.text = "Element"
		1:
			$Category.text = "Style"
		2:
			$Category.text = "Shape"
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

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		_on_exit_pressed()

func _on_element_pressed():
	if(reset("Element", selectedSpell.element, 0)):
		selectedSpell.element = []
		_changeSpell(selectedSpell)
		_change(0)

func _on_style_pressed():
	if(reset("Style", selectedSpell.style, 1)):
		selectedSpell.style = []
		_changeSpell(selectedSpell)
		_change(1)

func _on_spell_type_pressed():
	if(reset("Type", selectedSpell.type, 2)):
		selectedSpell.type = null
		_changeSpell(selectedSpell)
		_change(2)

func _on_settings_pressed():
	$Node2D.visible = true
	$Node2D.on_open()

func _on_exit_pressed():
	if(!dontLeave):
		queue_free()

func _on_cancel_pressed():
	$SpellCreation.cancel()
	_finish()
