extends Control

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

# Called when the node enters the scene tree for the first time.
func _ready():
	amountShot = Global.amountShot
	amountHit = Global.amountHit
	multiHits = Global.multiHits
	damageTaken = Global.damageTaken
	damageBlocked = Global.damageBlocked
	damageHealed = Global.damageHealed
	damageDealt = Global.damageDealt
	spellsCasted = Global.spellsCasted
	perfectBlocks = Global.perfectBlocks
	goodBlocks = Global.goodBlocks
	badBlocks = Global.badBlocks
	noBlocks = Global.noBlocks
	enemiesKilled = Global.enemiesKilled

func _process(delta):
	if(get_child_count() == 0):
		Global._change_tscn("res://World/Screens/MainMenu.tscn")
