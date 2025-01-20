extends Control

@export var cook: TypeSpellCard

@onready var page = preload("res://SpellPage.tscn")

var spell = Global.spellList[0]
var pageNum = 0
var maxPages = 0

func _ready():
	$TableOfContents.change_page.connect(change_page)
	$SpellPage.visible = false
	$TableOfContents.spell = spell
	$SpellPage.spell = spell
	$TableOfContents.exist()
	
func _input(event: InputEvent):
	if(event is InputEventMouseButton and event.pressed):
		var mp = get_global_mouse_position()
		if(mp.x >= Constants.SCREEN_SIZE.x/2 + 150 and mp.x <= Constants.SCREEN_SIZE.x/2 + 300):
			updateMaxPages()
			print("right")
			if (pageNum < maxPages):
				$SpellPage.change(pageNum)
				pageNum += 1
		if(mp.x <= Constants.SCREEN_SIZE.x/2 - 150 and mp.x >= Constants.SCREEN_SIZE.x/2 - 300):
			updateMaxPages()
			print("left")
			if(pageNum == 1):
				pageNum -= 1
				$SpellPage.visible = false
			elif(pageNum >1):
				pageNum -= 1
				$SpellPage.change(pageNum - 1)
	

func updateMaxPages():
	maxPages = 1
	if(spell.type):
		maxPages += 1
	maxPages += spell.element.size() + spell.style.size()

func change_page(val):
	pageNum = val
	$SpellPage.change(val - 1)
	
func _on_exit_pressed():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Pause") and visible):
		_on_exit_pressed()
