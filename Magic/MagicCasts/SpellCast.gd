extends Node2D
class_name SpellCast

var spell : Spell
var holding : bool = true
var sender : CharacterBody2D = null
var anim_base : float = 10.0
var anim_slow : int = 2

func _on_release() -> void:
	holding = false

func _castingAnimationCalc(time: float,maxtime: float) -> float:
	return (-pow(anim_base,-anim_slow * (maxtime-time)/maxtime)+1.0)
