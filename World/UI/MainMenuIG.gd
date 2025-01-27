extends Control

@onready var MagicCreation = preload("res://Magic/MagicCreationMenu.tscn")
#@onready var MagicCreation = preload("res://SpellCreation.tscn")
@onready var InputChangeSystem = preload("res://World/UI/input_change_system.tscn")
@onready var Stats = preload("res://World/Screens/Stats.tscn")

var timer = 0

func _show():
	visible = true
	Global.pause[0] = 1
	timer = 10

func _process(delta):
	timer -= 1
	if Input.is_action_just_pressed("Pause") and get_children().size() <= 3 and timer <= 0:
		_on_exit_pressed()

func _on_magic_creation_pressed():
	var magicCreation = MagicCreation.instantiate()
	add_child(magicCreation)

func _on_input_change_pressed():
	var inputChangeSystem = InputChangeSystem.instantiate()
	inputChangeSystem._exitShown()
	add_child(inputChangeSystem)

func _on_stats_pressed():
	var stats = Stats.instantiate()
	add_child(stats)

func _on_exit_pressed():
	visible = false
	Global.pause[0] = 0
	get_tree().current_scene._reloadSpellList()

func _on_check_button_pressed():
	Global.particlesNotShowing = !Global.particlesNotShowing
