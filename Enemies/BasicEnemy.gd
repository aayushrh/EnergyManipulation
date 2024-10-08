extends CharacterBody2D

var player = null
var cooldown = 5
var can_attack = true
var slow = false
var effects = []

@export var cooldownAttack : float
@export var TOPSPEED : int
@export var ROTATIONSPEED : float
@export var Shockwave : PackedScene

@export var art : Node2D
@export var softBody : Area2D

func _ready():
	art.finishCharge.connect(_finishCharge)
	art.hit.connect(_shockwave)

func _finishCharge():
	slow = false
	ROTATIONSPEED *= 2

func _process(delta):
	if(!Global.pause):
		_effectsHandle()
		_move(delta)

func _effectsHandle():
	for e in effects:
		e._tick()

func _move(delta):
	var softBodyPush = $SoftBody.getVector()
	
	cooldown -= delta
	if(cooldown <=0):
		can_attack = true
	if player != null:
		rotateToTarget(player, delta)
		#rotation_degrees += 90
		velocity = (player.global_position - global_position).normalized() * TOPSPEED
		velocity -= softBodyPush * TOPSPEED
		if(slow):
			velocity = velocity * 0.5
		move_and_slide()
		
		if(dist(player, self) <= 250) and can_attack:
			_punch()
			can_attack = false
			slow = true
			ROTATIONSPEED /= 2
			cooldown = cooldownAttack

func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = transform.x.angle_to(direction) + PI/2
	rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func _punch():
	art._startPunch()

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
