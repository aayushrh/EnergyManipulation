extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var ACCELERATION : float
@export var FRICTION : float
@export var TOPSPEED : float
@export var TURNINGSPEED : float
@export var DASHSPEED : float
@export var DASHTIME : float
@export var ROTATIONSPEED : float

@export_group("Effects")
@export var Shockwave : PackedScene
@export var Afterimage : PackedScene

@onready var Blast = preload("res://Magic/MagicCasts/Blast.tscn")
@onready var Explosion = preload("res://Magic/MagicCasts/Explosion.tscn")

var type = 0
var rng = RandomNumberGenerator.new()
var right = true
var can_attack = true
var clicked = ""
var timer = 120
var dashing = false
var blocking = false
var time = 0
var stored_energy = 10.0
var dmgTaken = 0
var time_last_block = -1
var time_last_hit = 0
var health = 10
var slow = false
var rotation_speed = 0
var onLastTurn = false
var effects = []

func _ready():
	updateEnergy()
	$PlayerArt.hit.connect(_shockwave)
	rotation_speed = ROTATIONSPEED

func _process(delta):
	time += delta
	queue_redraw()
	if(!Global.pause and !dashing):
		_effectsHandle()
		magic_check(delta)
		rotateToTarget(get_global_mouse_position(), delta)
		_movement()
		attack()
		dash_check()
		block()
	if(dashing):
		var after = Afterimage.instantiate()
		after.global_position = global_position
		after.rotation_degrees = rotation_degrees
		get_tree().current_scene.add_child(after)
	if(!Global.pause): move_and_slide()

func block():
	if(Input.is_action_just_pressed("Block")):
			$PlayerArt._block()
			blocking = true
			time_last_block = time
	if(Input.is_action_just_released("Block") and blocking):
		$PlayerArt._unblock()
		blocking = false

func _draw():
	if(blocking):
		draw_arc(Vector2.ZERO, 50, -PI/4, -3*PI/4, 20, Color.WHITE, 5)

func updateEnergy():
	$CanvasLayer/EnergyBar.size.x = stored_energy*50

func magic_check(delta):
	var hit = false
	for e in Global.spellList:
		if(!e.using):
			e.cooldown -= delta
		if e.binding != null:
			if Input.is_key_pressed(e.binding):
				hit = true
			if Input.is_key_pressed(e.binding) and !onLastTurn and e.cooldown < 0:
				if(e.type != null and e.type.spellName.to_lower() == "blast"):
					var blast = Blast.instantiate()
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
				stored_energy -= e.initCost()
				updateEnergy()
	onLastTurn = hit

func dash_check():
	if(Input.is_action_pressed("Dash")):
		var input_vector = Vector2.ZERO
		input_vector.y = Input.get_axis("up", "down")
		input_vector.x = Input.get_axis("left", "right")
		input_vector = input_vector.normalized()
		dash(input_vector)
	elif(InputMap.action_get_events("Dash").size() == 0):
		_doubleClickCheck()

func _doubleClickCheck():
	var justClicked = ""
	var dir = Vector2.ZERO
	if(Input.is_action_just_pressed("down")):
		justClicked = "s"
		dir = Vector2(0, 1)
	if(Input.is_action_just_pressed("up")):
		justClicked = "w"
		dir = Vector2(0, -1)
	if(Input.is_action_just_pressed("left")):
		justClicked = "a"
		dir = Vector2(-1, 0)
	if(Input.is_action_just_pressed("right")):
		justClicked = "d"
		dir = Vector2(1, 0)
	if(justClicked != ""):
		if(clicked == justClicked):
			dash(dir)
		else:
			clicked = justClicked
			timer = 120
	if clicked != "" :
		timer -= 1
		if timer <= 0:
			clicked = ""

func dash(dir):
	velocity = dir * DASHSPEED
	dashing = true
	$DashingTimer.start(DASHTIME)
	clicked = ""
	timer = 60
	blocking = false
	$PlayerArt._unblock()

func _shockwave():
	var shockwave = Shockwave.instantiate()
	shockwave.global_position = global_position
	shockwave.rotation_degrees = rotation_degrees
	shockwave.sender = self
	shockwave.energy = 1
	updateEnergy()
	get_tree().current_scene.add_child(shockwave)

func attack():
	pass
	#if Input.is_action_just_pressed("Hit") and !blocking:
		#$PlayerArt._click()

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	rotation_degrees -= 90
	var angleTo = transform.x.angle_to(direction)
	rotation_degrees += 90
	rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func _effectsHandle():
	for e in effects:
		e._tick(self)

func _movement():
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_axis("up", "down")
	input_vector.x = Input.get_axis("left", "right")
	input_vector = input_vector.normalized()
	velocity += input_vector * ACCELERATION
	velocity *= FRICTION
	if(!blocking and !slow):
		velocity = velocity.limit_length(TOPSPEED)
	else:
		velocity = velocity.limit_length(TOPSPEED/2)

func _hit(hitbox):
	dmgTaken = hitbox.damageTaken(self)
	time_last_hit = time
	_hit_register()

func _dmgRed(time):
	if(time > 0 and time < 0.0417):
		return 1
	if(time > 0.0417 and time < 0.0833):
		return (((0.0833 - time)/(0.0416)) * 0.15) + 0.85
	if(time > 0.0833 and time < 0.125):
		return (-13.68 + 3.173*(time*100) + 0.02387*pow((time*100), 2))/100.0
	return 0
	
func doneCasting():
	slow = false
	ROTATIONSPEED *= 2

func _on_dashing_timer_timeout():
	dashing = false

func _hit_register():
	var dmgRed = _dmgRed(abs(time_last_hit-time_last_block))
	print("timeDiff: " + str(abs(time_last_hit-time_last_block)))
	print("damage: " + str(dmgTaken * (1-dmgRed)))
	print("dmg Reduction: " + str(dmgTaken - dmgTaken * (1-dmgRed)))
	print("stored Energy increase: " + str(dmgTaken * (dmgRed)))
	stored_energy += dmgTaken * dmgRed * 10
	health -= dmgTaken * (1-dmgRed)
	if(health<0):
		Global._change_tscn("res://World/Screens/MainMenu.tscn")
		Global.pause = false
	updateEnergy()
	$CanvasLayer/HealthBar.size.x = health*10.0
	time = 0
	time_last_block = -1
