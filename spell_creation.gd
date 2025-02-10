extends Control

@onready var page = preload("res://SpellPage.tscn")

@export var MagicMenu: Control
@export var SpellList: VBoxContainer

@export var  MAXPRESSTIME = 0.25

var spell = Global.spellList[0]
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
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
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
	maxPages += spell.element.size() + spell.style.size()

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
	
func _on_exit_pressed():
	visible = false
	MagicMenu.dontLeave = false
	
func nuhuh():
	pressed_timer = 0
	
func reset():
	spell = MagicMenu.selectedSpell
	visible = false
	if(spell != null):
		MagicMenu.dontLeave = true
		visible = true
		$Cover.on_open()
		$TableOfContents.visible = false
		$SpellPage.visible = false
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
		MagicMenu.dontLeave = true
		visible = true
		if forward:
			change_page(pageNum + 1)
		else:
			change_page(pageNum - 1)
		updateMaxPages()
		$TableOfContents.spell = spell
		$SpellPage.spell = spell
		$TableOfContents.reset()
		get_parent()._finish()
		dontTurn = false

func getCurrentPage():
	var num = pageNum - 1
	if(num <= spell.element.size()):
		return num
	else:
		return num - spell.style.size()

func cancel():
	dontTurn = false

func _on_add_right_pressed():
	dontTurn = true
	var num = pageNum - 2
	if(num <= spell.element.size()):
		get_parent().addCard(0)
	else:
		get_parent().addCard(1)

func _on_right_pressed():
	pageRight()

func _on_left_pressed():
	pageLeft()

func _on_delete_pressed():
	var cardRemoved = null
	if(pageNum - 1 <= spell.element.size()):
		cardRemoved = spell.element[getCurrentPage() - 1]
		spell.element.remove_at(getCurrentPage() - 1)
	else:
		cardRemoved = spell.style[min(spell.style.size() - 1, getCurrentPage() - 2)]
		spell.style.remove_at(min(spell.style.size() - 1, getCurrentPage() - 2))
	reload(false)
	Global.magicCards.append(cardRemoved)
