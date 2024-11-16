extends Control

@onready var MagicCreation = preload("res://Magic/MagicCreationMenu.tscn")
@onready var InputChangeSystem = preload("res://World/UI/input_change_system.tscn")

func _on_magic_creation_pressed():
	var magicCreation = MagicCreation.instantiate()
	add_child(magicCreation)

func _on_input_change_pressed():
	var inputChangeSystem = InputChangeSystem.instantiate()
	add_child(inputChangeSystem)

func _on_stats_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	visible = false
	Global.pause = false
