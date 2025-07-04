extends Node2D

var amountShot = 0
var amountHit = 0
var multiHits = 0
var damageTaken = 0
var damageBlocked = 0
var damageHealed = 0
var damageDealt = 0
var spellsCasted = 0
var perfectBlocks = 0
var goodBlocks = 0
var badBlocks = 0
var noBlocks = 0
var enemiesKilled = 0

@export var player : CharacterBody2D
@export var camera : Camera2D
@export var testComponentSpellCard : Array[ComponentSpellCard]
@export var testTypeSpellCard : TypeSpellCard
@export var testComponentSpellCard2 : Array[ComponentSpellCard]
@export var testTypeSpellCard2 : TypeSpellCard
@export var allComponentSpellCards : Array[ComponentSpellCard]
@export var allTypeSpellCards : Array[TypeSpellCard]
@export var defaultElement : ComponentSpellCard

@onready var Indicator = preload("res://Effects/EnemyIndicator.tscn")

func _ready():
	var spell : Spell = Spell.new("Fireball")
	spell.components = testComponentSpellCard
	spell.type = testTypeSpellCard
	spell.binding = 69
	#var spell2 = Spell.new("Fireball2")
	#spell2.components = testComponentSpellCard2
	#spell2.type = testTypeSpellCard2
	#spell2.binding = 69
	#Global.magicCards = testComponentSpellCard
	#Global.magicCards.append(testTypeSpellCard)
	Global.spellList = [spell]#, spell2]
	Global.defaultElement = defaultElement
	$CanvasLayer/ScrollContainer/SpellListUI.reload()

func _process(delta):
	
	$CanvasLayer/Label.text = "FPS: " + str(round(1/delta))
	
	if Input.is_action_just_pressed("Pause") and !$CanvasLayer/MainMenu.visible:
		$CanvasLayer/MainMenu._show()
		Global.pause[0] = 1
		$CanvasLayer/ScrollContainer/SpellListUI.reload()
	for e in $Enemies.get_children():
		var cameraPos = camera.get_screen_center_position()
		var placed = false
		if e.global_position.x > cameraPos.x + 1440/2:
			var indicator = Indicator.instantiate()
			indicator.global_position = lineLine(player.global_position.x, player.global_position.y, e.global_position.x, e.global_position.y, cameraPos.x + 1440/2, cameraPos.y + 812/2, cameraPos.x + 1440/2, cameraPos.y - 812/2) - Vector2(50, 0)
			indicator.rotation_degrees = 180/PI * atan2(e.global_position.y - indicator.global_position.y, e.global_position.x - indicator.global_position.x)
			if(indicator.global_position != Vector2(-50, 0)):
				get_tree().current_scene.add_child(indicator)
				placed = true
		if !placed and e.global_position.x < cameraPos.x - 1440/2:
			var indicator = Indicator.instantiate()
			indicator.global_position = lineLine(player.global_position.x, player.global_position.y, e.global_position.x, e.global_position.y, cameraPos.x - 1440/2, cameraPos.y + 812/2, cameraPos.x - 1440/2, cameraPos.y - 812/2) - Vector2(-50, 0)
			indicator.rotation_degrees = 180/PI * atan2(e.global_position.y - indicator.global_position.y, e.global_position.x - indicator.global_position.x)
			if(indicator.global_position != Vector2(50, 0)):
				get_tree().current_scene.add_child(indicator)
				placed = true
		if !placed and e.global_position.y > cameraPos.y + 812/2:
			var indicator = Indicator.instantiate()
			indicator.global_position = lineLine(player.global_position.x, player.global_position.y, e.global_position.x, e.global_position.y, cameraPos.x + 1440/2.0, cameraPos.y + 812/2.0, cameraPos.x - 1440/2.0, cameraPos.y + 812/2.0) - Vector2(0, 50)
			indicator.rotation_degrees = 180/PI * atan2(e.global_position.y - indicator.global_position.y, e.global_position.x - indicator.global_position.x)
			if(indicator.global_position != Vector2(0, -50)):
				get_tree().current_scene.add_child(indicator)
		if !placed and e.global_position.y < cameraPos.y - 812/2:
			var indicator = Indicator.instantiate()
			indicator.global_position = lineLine(player.global_position.x, player.global_position.y, e.global_position.x, e.global_position.y, cameraPos.x + 1440/2.0, cameraPos.y - 812/2.0, cameraPos.x - 1440/2.0, cameraPos.y - 812/2.0) - Vector2(0, -50)
			indicator.rotation_degrees = 180/PI * atan2(e.global_position.y - indicator.global_position.y, e.global_position.x - indicator.global_position.x)
			if(indicator.global_position != Vector2(0, 50)):
				get_tree().current_scene.add_child(indicator)

func lineLine(x1, y1, x2, y2, x3, y3, x4, y4):
	var uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
	var uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

	if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1):
		var intersectionX = x1 + (uA * (x2-x1));
		var intersectionY = y1 + (uA * (y2-y1));
		return Vector2(intersectionX, intersectionY);
	return Vector2.ZERO;

func _reloadSpellList():
	$CanvasLayer/ScrollContainer/SpellListUI.reload()

func death():
	Global.amountShot = amountShot
	Global.amountHit = amountHit
	Global.multiHits = multiHits
	Global.damageTaken = damageTaken
	Global.damageBlocked = damageBlocked
	Global.damageHealed = damageHealed
	Global.damageDealt = damageDealt
	Global.spellsCasted = spellsCasted
	Global.perfectBlocks = perfectBlocks
	Global.goodBlocks = goodBlocks
	Global.badBlocks = badBlocks
	Global.noBlocks = noBlocks
	Global.enemiesKilled = enemiesKilled
	Global._change_tscn("res://World/Screens/FinalStats.tscn")
