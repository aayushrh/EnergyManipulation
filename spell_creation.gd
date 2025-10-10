extends Control

@onready var page = preload("res://SpellPage.tscn")

@export var MagicMenu: Control
@export var SpellList: VBoxContainer

@export var  MAXPRESSTIME = 0.25

var spell : Spell = Global.spellList[0]
var pageNum = 0
var maxPages = 0
var pressed_timer = 0
var dontTurn = false

func _ready():
	$Cover.MagicMenu = MagicMenu
	$Cover.SpellList = SpellList
	$TableOfContents.change_page.connect(change_page)
	$SpellPage.visible = false
	$SpellPage.noPageChange.connect(nuhuh)
	reset()

func _process(delta):
	if(pressed_timer>0):
		pressed_timer -= delta
		if(pressed_timer<0):
			pressed_timer = 0
	elif(pressed_timer<0):
		pressed_timer += delta
		if(pressed_timer>0):
			pressed_timer = 0

"""func _input(event: InputEvent):
	print(pageNum)
	var mp = get_global_mouse_position()
	if(visible):
		if(pressed_timer == 0):
			if(event is InputEventMouseButton and event.pressed):
				if(mp.x >= Constants.SCREEN_SIZE.x/2 + 150 and mp.x <= Constants.SCREEN_SIZE.x/2 + 300):
					pressed_timer = MAXPRESSTIME
				if(mp.x <= Constants.SCREEN_SIZE.x/2 - 150 and mp.x >= Constants.SCREEN_SIZE.x/2 - 300):
					pressed_timer = -MAXPRESSTIME
		elif(pressed_timer < 0 and (mp.x <= Constants.SCREEN_SIZE.x/2 - 150 and mp.x >= Constants.SCREEN_SIZE.x/2 - 300) and event.is_released()):
			pageLeft()
			pressed_timer = 0
		elif(mp.x >= Constants.SCREEN_SIZE.x/2 + 150 and mp.x <= Constants.SCREEN_SIZE.x/2 + 300 and event.is_released()):
			pageRight()
			pressed_timer = 0"""

func pageRight():
	if !dontTurn:
		updateMaxPages()
		if(pageNum == -1):
			$TableOfContents.visible = true
			$Cover._on_exit_pressed()
			pageNum += 1
		elif (pageNum < maxPages - 1):
			$SpellPage.change(pageNum)
			pageNum += 1
			
		if pageNum > 0:
			$AddRight.visible = true
		else:
			$AddRight.visible = false
			
		if pageNum > 1:
			$Delete.visible = true
		else:
			$Delete.visible = false

func pageLeft():
	if !dontTurn:
		updateMaxPages()
		if(pageNum == 0):
			pageNum -= 1
			$Cover.on_open()
			$TableOfContents.visible = false
		if(pageNum == 1):
			pageNum -= 1
			$SpellPage.visible = false
		elif(pageNum >1):
			pageNum -= 1
			$SpellPage.change(pageNum - 1)
		
		if pageNum > 0:
			$AddRight.visible = true
		else:
			$AddRight.visible = false
			
		if pageNum > 1:
			$Delete.visible = true
		else:
			$Delete.visible = false

func updateMaxPages():
	maxPages = 1
	if(spell.type):
		maxPages += 1
	maxPages += spell.components.size()

func updateAttr(value, at):
	for i in spell.attributes[pageNum - 2]:
		if i.attr == at:
			i._updateValue(value)
	MagicMenu.selectedSpell = spell
	MagicMenu.reloadSpell()

func change_page(val):
	pageNum = val
	$SpellPage.change(val - 1)
	if pageNum > 0:
		$AddRight.visible = true
	else:
		$AddRight.visible = false
		
	if pageNum > 1:
		$Delete.visible = true
	else:
		$Delete.visible = false
	
func nuhuh():
	pressed_timer = 0
	
func reset():
	spell = MagicMenu.selectedSpell
	visible = false
	if(spell != null):
		visible = true
		$Cover.on_open()
		$TableOfContents.visible = false
		$SpellPage.visible = false
		$AddRight.visible = false
		$Delete.visible = false
		pageNum = -1
		updateMaxPages()
		$TableOfContents.spell = spell
		$SpellPage.spell = spell
		$TableOfContents.reset()

func reload(forward):
	if forward:
		spell = MagicMenu.selectedSpell
	visible = false
	if(spell != null):
		visible = true
		if forward:
			change_page(pageNum + 1)
		else:
			change_page(pageNum - 1)
		updateMaxPages()
		$TableOfContents.spell = spell
		$SpellPage.spell = spell
		$SpellPage.pageNum = pageNum
		$TableOfContents.reset()
		get_parent()._finish()
		dontTurn = false
		MagicMenu.dontLeave = false

func getCurrentPage():
	var num = pageNum - 1
	return num

func cancel():
	dontTurn = false
	MagicMenu.dontLeave = false

func _on_add_right_pressed():
	dontTurn = true
	MagicMenu.dontLeave = true
	var num = pageNum - 2
	get_parent().addCard(0)

func _on_right_pressed():
	pageRight()

func _on_left_pressed():
	pageLeft()

func _on_delete_pressed():
	var cardRemoved = null
	if(pageNum - 1 <= spell.components.size()):
		cardRemoved = spell.components[getCurrentPage() - 1]
		spell.attributes.remove_at(getCurrentPage())
		print(spell.attributes)
		spell.components.remove_at(getCurrentPage() - 1)
	reload(false)
	Global.magicCards.append(cardRemoved)
