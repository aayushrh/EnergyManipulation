extends Node

var pause = [0,0]#pos 0 is menu pause, 1 is selection pause
var lastTSCN = ""

var magicCards = []
var spellList = []
var particlesNotShowing = false

var timeScale = 1.0

var defaultElement : ComponentSpellCard

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
var hasDoneTutorial = false
var intel = 0
var wis = 0
var agl = 0
var con = 0
var com = 0#communism
var free = 0

func unPause():
	for i in pause.size():
		pause[i] = 0

func isPaused():
	for i in pause.size():
		if(pause[i] == 1):
			return true
	return false
func _change_tscn(file_location:String):
	lastTSCN = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(file_location)
	
func getTimeScale():
	if(isPaused()):
		return 0
	return timeScale
