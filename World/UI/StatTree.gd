extends Control

signal finishedSelecting()

@export var cardSelection : Control
var intel = 0
var wis = 0
var agl = 0
var con = 0
var com = 0#communism

func _ready():
	cardSelection.connect("finishedSelecting", _show)

func logWithBase(value, base): return log(value) / log(base)

func _show():
	Global.pause[1] = 1
	visible = true
	$ColorRect2/VBoxContainer/ColorRect3/HBoxContainer/Label2.text = str(agl)
	$ColorRect2/VBoxContainer/ColorRect/HBoxContainer/Label2.text = str(intel)
	$ColorRect2/VBoxContainer/ColorRect2/HBoxContainer/Label2.text = str(wis)
	$ColorRect2/VBoxContainer/ColorRect4/HBoxContainer/Label2.text = str(con)
	$ColorRect2/VBoxContainer/ColorRect5/HBoxContainer/Label2.text = str(com)

func _hide():
	if(Global.pause[0] != 1):
		Global.pause[1] = 0
	visible = false
	finishedSelecting.emit()

func _on_intel_pressed():
	if visible and Global.pause[0] != 1:
		intel += 1
		get_tree().current_scene.player.intel *= 1.05
		_hide()

func _on_wisdom_pressed():
	if visible and Global.pause[0] != 1:
		wis += 1
		get_tree().current_scene.player.wisdom *= 1.05
		_hide()

func _on_agility_pressed():
	if visible and Global.pause[0] != 1:
		agl += 1
		get_tree().current_scene.player.TOPSPEED *= 1.05
		get_tree().current_scene.player.maxDashCharges += 0.5
		get_tree().current_scene.player.DASHCD /= 1.05
		_hide()

func _on_const_pressed():
	if visible and Global.pause[0] != 1:
		con += 1
		get_tree().current_scene.player.MAXHEALTH *= 1.1
		get_tree().current_scene.player.health *= 1.1/get_tree().current_scene.player.healing
		get_tree().current_scene.player.healing *=1.05
		_hide()


func _on_comp_pressed() -> void:
	if visible and Global.pause[0] != 1:
		com += 1
		get_tree().current_scene.player.comprehension *= 1.05
		get_tree().current_scene.player.BLOCKCD /= 1.05
		get_tree().current_scene.player.maxBlockCharges += 0.25
		_hide()
