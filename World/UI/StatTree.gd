extends Control

signal finishedSelecting()

@export var cardSelection : Control

func _ready():
	cardSelection.connect("finishedSelecting", _show)

func _show():
	Global.pause = true
	visible = true

func _hide():
	Global.pause = false
	visible = false
	finishedSelecting.emit()

func _on_intel_pressed():
	if visible:
		get_tree().current_scene.player.intel += 1.2
		_hide()

func _on_wisdom_pressed():
	if visible:
		get_tree().current_scene.player.wisdom += 1.2
		_hide()

func _on_agility_pressed():
	if visible:
		get_tree().current_scene.player.TOPSPEED *= 1.2
		_hide()

func _on_const_pressed():
	if visible:
		get_tree().current_scene.player.maxHealth *= 1.2
		get_tree().current_scene.player.health *= 1.2
		_hide()
