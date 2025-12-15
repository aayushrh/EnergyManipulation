extends Node2D

var order = 1
var queued = false
var punching = false

@export var animationTree : AnimationTree

signal hit

func _click():
	if(punching):
		queued = true
	else:
		order = 1
		_hit()

func _process(delta):
	global_rotation_degrees = 0;
	animationTree.set("parameters/BlendTree/TimeScale/scale", Global.timeScale)

func _set_velocity(velocity : Vector2):
	animationTree.set("parameters/BlendTree/StateMachine/conditions/run", velocity.length() > 70 * Global.timeScale)
	animationTree.set("parameters/BlendTree/StateMachine/conditions/idle", velocity.length() < 70 * Global.timeScale)
	$Sprite.flip_h = velocity.x < 0
	
func _dash(cur):
	animationTree.set("parameters/BlendTree/StateMachine/conditions/dash", cur)
	animationTree.set("parameters/BlendTree/StateMachine/conditions/stop_dash", !cur)

func _block():
	if($AnimationPlayer.is_playing()):
		$AnimationPlayer.play("Block")

func _unblock():
	if($AnimationPlayer.is_playing()):
		$AnimationPlayer.play_backwards("Block")

func _hit():
	$AnimationPlayer.play("Punch-" + str(order))
	punching = true

func _on_animation_player_animation_finished(anim_name):
	if(anim_name.begins_with("Punch")):
		hit.emit()
		if(queued and order < 3):
			order += 1
			_hit()
		elif order <= 3:
			$AnimationPlayer.play("Return-" + str(order))
			order = 1
			punching = false
		queued = false
	else:
		punching = false
