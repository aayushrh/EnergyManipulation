extends Control

@export var Title: Label
@export var Size: HSlider
@export var Power: HSlider
@export var Stealth: HSlider
@export var MagicMenu: Control
@export var Name: TextEdit
@export var SpellList: VBoxContainer
@export var Keybind: Button

var changing = false
var keybind = 0

func on_open():
	MagicMenu.dontLeave = true
	Name.text = MagicMenu.selectedSpell.spellName
	if(!(MagicMenu.selectedSpell.attributes == null)):
		Size.value = MagicMenu.selectedSpell.attributes.size
		Power.value = MagicMenu.selectedSpell.attributes.power
		Stealth.value = MagicMenu.selectedSpell.attributes.amount
	Title.text = Name.text
	if MagicMenu.selectedSpell.binding != null:
		keybind = (MagicMenu.selectedSpell.binding)
		Keybind.text = (char)(keybind)
	else:
		Keybind.text = "Create new Keybind..."

func _on_exit_pressed():
	MagicMenu.dontLeave = false
	var location = Global.spellList.find(MagicMenu.selectedSpell)
	Global.spellList.remove_at(location)
	MagicMenu.selectedSpell.spellName = Name.text
	if keybind != 0:
		MagicMenu.selectedSpell.binding = keybind
	MagicMenu._changeSpell(MagicMenu.selectedSpell)
	Global.spellList.insert(location,MagicMenu.selectedSpell)
	SpellList.reload()
	visible=false

func _process(delta):
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
	if(Input.is_action_just_pressed("enter") and get_viewport().gui_get_focus_owner() == Name):
		print("Gay")
		var found = false
		Name.visible=false
		Name.visible=true
		Name.undo()
		for i in Global.spellList:
			if(Name.text == i.spellName):
				found = true
		if found or Name.text.length() >= 15:
			Name.text = MagicMenu.selectedSpell.spellName


func _on_deletion_pressed():
	Global.spellList.remove_at(Global.spellList.find(MagicMenu.selectedSpell))
	SpellList.reload()
	MagicMenu.control_invisible()
	#if(MagicMenu.selectedSpell.element!=null):
		#Global.magicCards.append(MagicMenu.selectedSpell.element)
	#if(MagicMenu.selectedSpell.style!=null):
		#Global.magicCards.append(MagicMenu.selectedSpell.style)
	if(MagicMenu.selectedSpell.type!=null):
		Global.magicCards.append(MagicMenu.selectedSpell.type)
	visible=false

func _input(event):
	if(event is InputEventKey and event.pressed and changing):
		keybind = (event.keycode)
		Keybind.text = (char)(keybind)
		changing = false
		Keybind.visible = false
		Keybind.visible = true
		

func _on_keybind_pressed():
	changing = true
