extends Node2D

signal hit
signal finishCharge

@export var particles : Node2D
@export var animPlayer : AnimationPlayer

func _kill():
	$AnimationPlayer.play("Death")

func _startPunch():
	animPlayer.play("Punch")

func _start_Charge():
	particles.emitting = true

func _finish_Charge():
	finishCharge.emit()
	particles.emitting = false

func _hit():
	hit.emit()

func _death():
	get_parent().queue_free()
