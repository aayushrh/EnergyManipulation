extends Node2D

func _ready():
	if Global.hasDoneTutorial:
		$Start.switching = "World"
	Global.spellList = []
