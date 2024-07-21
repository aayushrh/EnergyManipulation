extends CharacterBody2D

@export_group("Skin Color")
@export var lightest : CompressedTexture2D
@export var lighter : CompressedTexture2D
@export var light : CompressedTexture2D
@export var dark : CompressedTexture2D
@export var darkest : CompressedTexture2D
@export var skinTone = "Lighter"

@export_group("Movement")
@export var ACCELERATION : float
@export var FRICTION : float
@export var TOPSPEED : float
@export var TURNINGSPEED : float
@export var DASHSPEED : float
@export var DASHTIME : float

@export_group("Effects")
@export var Shockwave : PackedScene
@export var Afterimage : PackedScene

var rng = RandomNumberGenerator.new()
var right = true
var can_attack = true
var clicked = ""
var timer = 120
var dashing = false
var blocking = false
var time = 0
var stored_energy = 0.0
var dmgTaken = 0
var time_last_block = -1
var time_last_hit = 0
var health = 10

func _ready():
	_skinColor()

func _skinColor():
	var texture = null
	if skinTone == "Lightest":
		texture = lightest
	if skinTone == "Lighter":
		texture = lighter
	if skinTone == "Light":
		texture = light
	if skinTone == "Dark":
		texture = dark
	if skinTone == "Darkest":
		texture = darkest
	$Art/RArm.texture = texture
	$Art/LArm.texture = texture
	$Art/Body.texture = texture

func _process(delta):
	time += delta
	queue_redraw()
	if(!Global.pause and !dashing):
		_movement()
		_rotation()
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
			$AnimationPlayer.play("Block")
			blocking = true
			time_last_block = time
	if(Input.is_action_just_released("Block") and blocking):
		$AnimationPlayer.play_backwards("Block")
		blocking = false

func _draw():
	if(blocking):
		draw_arc(Vector2.ZERO, 50, -PI/4 - PI/8, -3*PI/4 - PI/8, 20, Color.WHITE, 5)

func dash_check():
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
	$AnimationPlayer.play_backwards("Block")

func attack():
	if !$AnimationPlayer.is_playing() and Input.is_action_just_pressed("Hit") and !blocking:
		if right:
			$AnimationPlayer.play("RightPunch")
		else:
			$AnimationPlayer.play("LeftPunch")
		right = !right
		if(can_attack):
			var shockwave = Shockwave.instantiate()
			shockwave.global_position = global_position
			shockwave.rotation_degrees = rotation_degrees
			shockwave.sender = self
			#shockwave.energy = max(min(stored_energy, 1), 0.05)
			shockwave.energy = 1
			#stored_energy -= min(stored_energy, 1)
			$CanvasLayer/EnergyBar.size.x = stored_energy*100
			get_tree().current_scene.add_child(shockwave)

func _rotation():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	rotation_degrees += 90

func _movement():
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_axis("up", "down")
	input_vector.x = Input.get_axis("left", "right")
	input_vector = input_vector.normalized()
	velocity += input_vector * ACCELERATION
	velocity *= FRICTION
	if(!blocking):
		velocity = velocity.limit_length(TOPSPEED)
	else:
		velocity = velocity.limit_length(TOPSPEED/2)

func _hit(hitbox):
	dmgTaken = hitbox.damageTaken(self)
	$HitRegisterTimer.start(0.15)
	time_last_hit = time

func _dmgRed(time):
	if(time > 0 and time < 0.0417):
		return 1
	if(time > 0.0417 and time < 0.0833):
		return (((0.0833 - time)/(0.0416)) * 0.15) + 0.85
	if(time > 0.0833 and time < 0.125):
		return (-13.68 + 3.173*(time*100) + 0.02387*pow((time*100), 2))/100.0
	return 0
	

func _on_dashing_timer_timeout():
	dashing = false

func _on_hit_register_timer_timeout():
	var dmgRed = _dmgRed(abs(time_last_hit-time_last_block))
	print("timeDiff: " + str(abs(time_last_hit-time_last_block)))
	print("damage: " + str(dmgTaken * (1-dmgRed)))
	print("dmg Reduction: " + str(dmgTaken - dmgTaken * (1-dmgRed)))
	print("stored Energy increase: " + str(dmgTaken * (dmgRed)))
	stored_energy += dmgTaken * dmgRed
	health -= dmgTaken * (1-dmgRed)
	if(health<0):
		Global._change_tscn("res://MainMenu.tscn")
	$CanvasLayer/EnergyBar.size.x = stored_energy*100.0
	$CanvasLayer/HealthBar.size.x = health*10.0
	time = 0
	time_last_block = -1
