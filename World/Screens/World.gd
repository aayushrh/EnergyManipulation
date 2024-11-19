extends Node2D

var amountShot = 0
var amountHit = 0
var damageTaken = 0
var damageBlocked = 0
var damageHealed = 0

func _ready():
	Global.magicCards = [SpellCard.new(0, "Fire"), SpellCard.new(2, "Blast")]
	Global.spellList = []
	$CanvasLayer/ScrollContainer/SpellListUI.reload()

func _process(delta):
	if Input.is_action_just_pressed("Pause") and !$CanvasLayer/MainMenu.visible:
		$CanvasLayer/MainMenu._show()
		Global.pause = true
		$CanvasLayer/ScrollContainer/SpellListUI.reload()
		print("true")

func _reloadSpellList():
	$CanvasLayer/ScrollContainer/SpellListUI.reload()
