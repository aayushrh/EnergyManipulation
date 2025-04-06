extends Node2D
class_name SpellCast

var spell : Spell
var holding : bool = true
var sender : CharacterBody2D = null

func _on_release() -> void:
	holding = false
