extends Node2D

signal hit
signal finishCharge

func _startPunch():
	$AnimationPlayer.play("Punch")

func _start_Charge():
	$RArm/Charging.emitting = true

func _finish_Charge():
	finishCharge.emit()
	$RArm/Charging.emitting = false

func _hit():
	hit.emit()
