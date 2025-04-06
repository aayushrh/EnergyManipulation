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

enum {
	MOVEMENT,
	DASH,
	BLOCK,
	MAGIC,
	PAUSE,
	MAGICCREATION,
	PERFECTBLOCK,
	DONE
}

var state = MOVEMENT

@export var testComponentSpellCard : Array[ComponentSpellCard]
@export var testTypeSpellCard : TypeSpellCard
@export var tutorialElement : ComponentSpellCard
@export var defaultElement : ComponentSpellCard
@export var player : Player

@onready var Indicator = preload("res://Effects/EnemyIndicator.tscn")

func _ready():
	var spell = Spell.new("Fireball")
	spell.components = testComponentSpellCard
	spell.type = testTypeSpellCard
	spell.binding = 69
	#Global.magicCards = testComponentSpellCard
	#Global.magicCards.append(testTypeSpellCard)
	Global.defaultElement = defaultElement
	Global.spellList = [spell]
	$CanvasLayer/ScrollContainer/SpellListUI.reload()
	$CanvasLayer/MovementTip.visible = true
	Global.pause[0] = 1

func _process(delta):
	player.blockCharges = 3
	match state:
		MOVEMENT:
			if player.position != Vector2.ZERO:
				state = DASH
				$CanvasLayer/DashTip.visible = true
				Global.pause[0] = 1
		DASH:
			if player.dashing:
				state = BLOCK
				$CanvasLayer/BlockTip.visible = true
				Global.pause[0] = 1
		BLOCK:
			if player.blocking:
				state = MAGIC
				$CanvasLayer/MagicTip.visible = true
				Global.pause[0] = 1
		MAGIC:
			if amountShot > 0:
				state = PAUSE
				$CanvasLayer/PauseTip.visible = true
				Global.pause[0] = 1
		PAUSE:
			if !$CanvasLayer/PauseTip.visible and Global.isPaused():
				state = MAGICCREATION
				$CanvasLayer/MagicCreationTip.visible = true
		MAGICCREATION:
			if !Global.isPaused():
				$Sentry.visible = true
				$Sentry.player = player
				state = PERFECTBLOCK
				Global.pause[0] = 1
				$CanvasLayer/PerfectBlockTip.visible = true
		PERFECTBLOCK:
			if perfectBlocks >= 5:
				state = DONE
				$Sentry.visible = false
				$Sentry.player = null
				Global.pause[0] = 1
				$CanvasLayer/DoneTip.visible = true
	
	$CanvasLayer/Label.text = "FPS: " + str(round(1/delta))
	
	if Input.is_action_just_pressed("Pause") and !$CanvasLayer/MainMenu.visible:
		$CanvasLayer/MainMenu._show()
		Global.pause[0] = 1
		$CanvasLayer/ScrollContainer/SpellListUI.reload()

func _reloadSpellList():
	$CanvasLayer/ScrollContainer/SpellListUI.reload()

func _on_movement_tip_button_down():
	$CanvasLayer/MovementTip.visible = false
	Global.unPause()

func _on_dash_tip_button_down():
	$CanvasLayer/DashTip.visible = false
	Global.unPause()

func _on_block_tip_button_down():
	$CanvasLayer/BlockTip.visible = false
	Global.unPause()

func _on_magic_tip_button_down():
	$CanvasLayer/MagicTip.visible = false
	Global.unPause()

func _on_pause_tip_button_down():
	$CanvasLayer/PauseTip.visible = false
	Global.unPause()

func _on_magic_creation_tip_button_down():
	$CanvasLayer/MagicCreationTip.visible = false

func _on_perfect_block_tip_button_down():
	$CanvasLayer/PerfectBlockTip.visible = false
	Global.unPause()

func _on_done_tip_button_down():
	Global.unPause()
	Global.hasDoneTutorial = true
	Global._change_tscn("res://World/Screens/World.tscn")
