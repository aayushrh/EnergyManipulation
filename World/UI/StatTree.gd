extends Control

signal finishedSelecting()

@export var cardSelection : Control

func _ready():
	cardSelection.connect("finishedSelecting", _show)

func logWithBase(value, base): return log(value) / log(base)

func _show():
	Global.pause[1] = 1
	visible = true
	$ColorRect2/VBoxContainer/ColorRect3/HBoxContainer/Label2.text = str(logWithBase(get_tree().current_scene.player.base_top_speed/500, 1.2))
	$ColorRect2/VBoxContainer/ColorRect/HBoxContainer/Label2.text = str((get_tree().current_scene.player.intel-1)/0.2)
	$ColorRect2/VBoxContainer/ColorRect2/HBoxContainer/Label2.text = str((get_tree().current_scene.player.wisdom-1)/0.2)
	$ColorRect2/VBoxContainer/ColorRect4/HBoxContainer/Label2.text = str(logWithBase(get_tree().current_scene.player.MAXHEALTH/20.0, 1.2))
	
func _hide():
	if(Global.pause[0] != 1):
		Global.pause[1] = 0
	visible = false
	finishedSelecting.emit()

func _on_intel_pressed():
	if visible and Global.pause[0] != 1:
		get_tree().current_scene.player.intel += 0.2
		_hide()

func _on_wisdom_pressed():
	if visible and Global.pause[0] != 1:
		get_tree().current_scene.player.wisdom += 0.2
		_hide()

func _on_agility_pressed():
	if visible and Global.pause[0] != 1:
		get_tree().current_scene.player.TOPSPEED *= 1.2
		get_tree().current_scene.player.base_top_speed *= 1.2
		_hide()

func _on_const_pressed():
	if visible and Global.pause[0] != 1:
		get_tree().current_scene.player.MAXHEALTH *= 1.2
		get_tree().current_scene.player.health *= 1.2
		_hide()


func _on_comp_pressed() -> void:
	if visible and Global.pause[0] != 1:
		get_tree().current_scene.player.comprehension += 0.2
		_hide()
