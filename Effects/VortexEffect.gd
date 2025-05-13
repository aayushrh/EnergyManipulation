extends CharacterBody2D

var parent = null

func _ready():
	if is_instance_valid(parent):
		velocity = (parent.global_position - global_position).normalized() * 5000
	else:
		queue_free()

func _physics_process(delta):
	delta *= Global.getTimeScale()
	if is_instance_valid(parent):
		velocity = (parent.global_position - global_position).normalized() * 5000 * delta#might be wrong
		if (parent.global_position - global_position).length() < 25:
			queue_free()
		move_and_slide()
	else:
		queue_free()
	#global_position += velocity * delta
