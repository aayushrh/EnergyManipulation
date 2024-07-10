extends CharacterBody2D

var player = null
var cooldown = 5
var can_attack = true
var slow = false

@export var cooldownAttack : float
@export var speed : int

@export var Shockwave : PackedScene

func _process(delta):
	if(!Global.pause):
		_move(delta)

func _move(delta):
	var softBodyPush = $SoftBody.getVector()
	
	cooldown -= delta
	if(cooldown <=0):
		can_attack = true
	if player != null:
		look_at(player.global_position)
		rotation_degrees += 90
		velocity = (player.global_position - global_position).normalized() * speed
		if(slow):
			velocity = velocity * 0.5
		velocity -= softBodyPush * speed
		move_and_slide()
		
		if(dist(player, self) <= 250) and can_attack:
			_punch()
			can_attack = false
			slow = true
			cooldown = cooldownAttack

func _punch():
	$AnimationPlayer.play("Charging")

func _on_vision_body_entered(body):
	player = body

func _hit(hitbox):
	print(hitbox.damageTaken(self))

func dist(a, b):
	var sub = a.global_position - b.global_position
	return sqrt(sub.x*sub.x + sub.y*sub.y)

func _shockwave():
	var shockwave = Shockwave.instantiate()
	shockwave.global_position = global_position
	shockwave.rotation_degrees = rotation_degrees
	shockwave.sender = self
	shockwave.energy = 1
	get_tree().current_scene.add_child(shockwave)
	slow = false

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "Charging"):
		$AnimationPlayer.play("Punch")
