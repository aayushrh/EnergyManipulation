extends Node

var pause = false
var lastTSCN = ""

var magicCards = [SpellCard.new(0, "Fire"), SpellCard.new(1, "Dragon"), SpellCard.new(2, "Blast"), SpellCard.new(0, "Water")]
var spellList = []

func _change_tscn(file_location:String):
	lastTSCN = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(file_location)
	print(lastTSCN)
