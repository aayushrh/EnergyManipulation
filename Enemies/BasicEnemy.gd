extends CharacterBody2D

var player = null
var cooldown = 5
var can_attack = true
var slow = false
var effects = []
var nomove = false
var dmgTaken = 0
var time = 0
var block = -1
var rng = RandomNumberGenerator.new()
var magic = []
var canDash = true
var type = 1
var moveDir = 0

@export var health : float

@export var checkBlasts : float # how oftden check blast, in sec
#@export var skillIssue : float
@export var checkAngle : float # angle checked for things that will be going towards them
@export var blockOrFlight : int # how many will have to be going for it to block
@export var tact : int # chance to do smarter things
@export var DASHSPEED : float
@export var cooldownAttack : float
@export var TOPSPEED : int
@export var ROTATIONSPEED : float
@export var Shockwave : PackedScene
@export var dash_cd : float
@export var dash_time : float
@export var block_cd : float
@export var min_range : int
@export var max_range : int

@export var art : Node2D
@export var softBody : Area2D

@onready var BlastTscn = preload("res://Magic/MagicCasts/Blast.tscn")
@onready var Explosion = preload("res://Magic/MagicCasts/Explosion.tscn")

var spells = []

func _ready():
	art.finishCharge.connect(_finishCharge)
	art.hit.connect(_shockwave)
	var spell = Spell.new("firstSpell")
	spell.type = SpellCard.new(2, "Blast")
	spells.append(spell)

func _finishCharge():
	slow = false
	ROTATIONSPEED *= 2

func _process(delta):
	if(!Global.pause):
		queue_redraw()
		time+=delta
		magic_check(delta)
		_effectsHandle()
		if(!nomove):
			_move(delta)
		move_and_slide()

func _effectsHandle():
	for e in effects:
		e._tick(self)

func _hit(hitbox):
	dmgTaken = hitbox.damageTaken(self)
	if(block>0):
		health -= dmgTaken*(1-_dmgRed(time-block))
		un_block()
	else:
		health -= dmgTaken
	time = 0

func _move(delta):
	var softBodyPush = $SoftBody.getVector()
	
	cooldown -= delta
	if(cooldown <=0):
		can_attack = true
	if player != null:
		rotateToTarget(player, delta)
		if((player.global_position - global_position).length() > max_range):
			#print((player.global_position - global_position).length())
			velocity = (player.global_position - global_position).normalized() * TOPSPEED
		elif((player.global_position - global_position).length() < min_range):
			velocity = (player.global_position - global_position).normalized() * -TOPSPEED
		awareness(delta)
		velocity -= softBodyPush * TOPSPEED
		if(slow):
			velocity = velocity * 0.5

func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = transform.x.angle_to(direction) + PI/2
	rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func _punch():
	art._startPunch()

func _on_vision_body_entered(body):
	player = body

func _dmgRed(time):
	if(time > 0 and time < 0.0417):
		return 1
	if(time > 0.0417 and time < 0.0833):
		return (((0.0833 - time)/(0.0416)) * 0.15) + 0.85
	if(time > 0.0833 and time < 0.125):
		return (-13.68 + 3.173*(time*100) + 0.02387*pow((time*100), 2))/100.0
	return 0

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

#in degrees
func is_this_thing_going_towards_me(angle, velo):
	return rad_to_deg(abs(angle-velo.angle()))<checkAngle

func is_this_thing_too_close_to_me(angle, vect, speed2):
	return (vect.length()*cos(angle) - speed2) < 0

func tactCheck(req):
	if(tact>=req):
		return randi_range(0,tact*2)>req
	else:
		return randi_range(tact,req+tact)>req

func magic_check(delta):
	for e in spells:
		if(!e.using):
			e.cooldown -= delta
		if(moveDir == 0 and e.cooldown < 0):
			if(e.type != null and e.type.spellName.to_lower() == "blast"):
				var blast = BlastTscn.instantiate()
				blast.player = self
				blast.setSpell(e)
				get_tree().current_scene.add_child(blast)
				e.resetCooldown(true)
			if(e.type != null and e.type.spellName.to_lower() == "explosion"):
				var explosion = Explosion.instantiate()
				explosion.player = self
				explosion.setSpell(e)
				get_tree().current_scene.add_child(explosion)
				e.resetCooldown(true)
			slow = true
			ROTATIONSPEED /= 2

func doneCasting():
	slow = false
	ROTATIONSPEED *= 2

func avgDir(arr):
	var ae = Vector2.ZERO
	for n in arr:
		ae+=(global_position-n.global_position).normalized()
	return ae.normalized()

func avgVelo(arr):
	var ae = Vector2.ZERO
	for n in arr:
		ae+=n.v.normalized()
	return ae.normalized()

func dash(dir):
	print("i tried")
	velocity = dir*DASHSPEED
	nomove = true
	canDash = false
	$dashing.start(dash_time)
	$dash_cd.start(dash_cd+dash_time)

func do_block():
	if(block==-1 and !nomove):
		block = time
		slow = true
		$block_cd.start(block_cd)

func _draw():
	if(block != -1):
		draw_arc(Vector2.ZERO, 50, -PI/4, -3*PI/4, 20, Color.WHITE, 5)

func un_block():
	block = -1
	slow = false

func perp_vector(vect):
	if(rng.randi_range(0,1)==1):
		return Vector2(vect.y,-vect.x)
	else:
		return Vector2(-vect.y,vect.x)

func set_perp_vector(vect, right):
	if(right):
		return Vector2(vect.y,-vect.x)
	else:
		return Vector2(-vect.y,vect.x)

func awareness(delta):
	var help = []
	for n in magic:
		if(n is Blast):
			var asdf = is_this_thing_going_towards_me((global_position-n.global_position).angle(),n.v)
			if(asdf):
				help.append(n)
	if(moveDir != 0 and help.size() <= 0):
		moveDir = 0
	for n in help:
		if(help.size()>=blockOrFlight):
			if(block == -1):
				if(canDash):
					if(tactCheck(100) and is_this_thing_too_close_to_me((global_position-n.global_position-n.v).angle(),n.v,DASHSPEED)):
						do_block()
					else:
						dash(avgDir(help))
				else:
					if(tactCheck(100) and is_this_thing_too_close_to_me((global_position-n.global_position-n.v).angle(),n.v,TOPSPEED)):
						do_block()
					else:
						velocity = avgDir(help) * TOPSPEED
		elif(block == -1):
			if(canDash):
				dash(perp_vector(avgDir(help)))
			else:
				#print(moveDir)
				if(moveDir == 0):
					#if(tactCheck(20)):
						moveDir = int((avgDir(help)-avgVelo(help)).angle()>0)*2-1
					#else:
					#	moveDir = rng.randi_range(0,1)*2-1
				velocity = set_perp_vector(avgDir(help),moveDir>0) * TOPSPEED

func _on_block_cd_timeout() -> void:
	un_block()

func _on_dash_cd_timeout() -> void:
	canDash = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	magic.append(area.get_parent())


func _on_area_2d_area_exited(area: Area2D) -> void:
	magic.remove_at(magic.find(area.get_parent()))


func _on_dashing_timeout() -> void:
	nomove = false
