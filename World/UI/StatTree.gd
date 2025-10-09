extends Control

@export var cardSelection : Control
var intel = Global.intel
var wis = Global.wis
var agl = Global.agl
var con = Global.con
var com = Global.com#communism
var free = Global.free : set = _freeChange

func _ready():
	update()
	print(Global.free)
	free = Global.free
	Global.pause[1] = 1

func logWithBase(value, base): return log(value) / log(base)

func _show():
	Global.pause[1] = 1
	visible = true
	

func update():
	$ColorRect2/VBoxContainer/ColorRect3/HBoxContainer/Label2.text = str(agl)
	$ColorRect2/VBoxContainer/ColorRect/HBoxContainer/Label2.text = str(intel)
	$ColorRect2/VBoxContainer/ColorRect2/HBoxContainer/Label2.text = str(wis)
	$ColorRect2/VBoxContainer/ColorRect4/HBoxContainer/Label2.text = str(con)
	$ColorRect2/VBoxContainer/ColorRect5/HBoxContainer/Label2.text = str(com)

func _hide():
	Global.pause[1] = 0
	Global.intel = intel
	Global.wis = wis
	Global.agl = agl
	Global.con = con
	Global.com = com
	Global.free = free
	queue_free()

func _freeChange(new):
	free = new
	if(free < 0):
		free = 0
	$ColorRect2/Label.text = "Available Stat Points: %s" % [free]

func isValidPress():
	if visible and free > 0:
		free -= 1
		return true 
	return false

func _on_intel_pressed():
	if isValidPress():
		intel += 1
		get_tree().current_scene.player.intel *= 1.025
		update()
		print(get_tree().current_scene.player.intel)

func _on_wisdom_pressed():
	if isValidPress():
		wis += 1
		get_tree().current_scene.player.wisdom *= 1.025
		get_tree().current_scene.player.MAXMANA *= 1.05
		update()

func _on_agility_pressed():
	if isValidPress():
		agl += 1
		get_tree().current_scene.player.TOPSPEED *= 1.025
		get_tree().current_scene.player.maxDashCharges += 0.25
		get_tree().current_scene.player.DASHCD /= 1.025
		update()

func _on_const_pressed():
	if isValidPress():
		con += 1
		get_tree().current_scene.player.MAXHEALTH *= 1.075
		get_tree().current_scene.player.commit_dmg(get_tree().current_scene.player.health * .075, {"hide":true})
		get_tree().current_scene.player.healing *= 1.0375
		update()


func _on_comp_pressed() -> void:
	if isValidPress():
		com += 1
		get_tree().current_scene.player.comprehension *= 1.05
		get_tree().current_scene.player.BLOCKCD /= 1.05
		get_tree().current_scene.player.maxBlockCharges += 0.25
		update()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		_hide()
