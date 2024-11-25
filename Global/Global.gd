extends Node

var pause = [0,0]#pos 0 is menu pause, 1 is selection pause
var lastTSCN = ""

var magicCards = []
var spellList = []
var particlesNotShowing = false

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
	print(lastTSCN)
