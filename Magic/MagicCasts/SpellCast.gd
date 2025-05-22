extends Node2D
class_name SpellCast

var spell : Spell
var holding : bool = true
var sender : CharacterBody2D = null
var anim_base = 10.0
var anim_slow = 2

func _on_release() -> void:
	holding = false

func _castingAnimationCalc(time: float,maxtime: float):
	return (-pow(anim_base,-anim_slow * (maxtime-time)/maxtime)+1.0)
