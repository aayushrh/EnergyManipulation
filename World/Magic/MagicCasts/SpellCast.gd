extends Node2D
class_name SpellCast

var spell : Spell
var holding = true
var player = null

func _on_release():
	holding = false

