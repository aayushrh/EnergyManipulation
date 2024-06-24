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

@export_group("Weapons")
@export var WeaponsScenes : Array[PackedScene]
@export var WeaponsSprite : Array[PackedScene]

@export_group("Effects")
@export var Shockwave : PackedScene
@export var Afterimage : PackedScene

var rng = RandomNumberGenerator.new()
var right = true
var switchingWeapons = false
var weapons = [Constants.IRONFISTS]
var can_attack = true
var clicked = ""
var timer = 120
var dashing = false
var blocking = false
var time_since_block = 0
var stored_energy = 0

func _ready():
	_checkWeapons()
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
	time_since_block += delta
	queue_redraw()
	if(!Global.pause and !dashing):
		_movement()
		_rotation()
		_attack()
		_dash_check()
		_block()
	if(dashing):
		var after = Afterimage.instantiate()
		after.global_position = global_position
		after.rotation_degrees = rotation_degrees
		get_tree().current_scene.add_child(after)
	_switchingWeapons()
	move_and_slide()

func _block():
	if(Input.is_action_just_pressed("Block")):
		$AnimationPlayer.play("Block")
		blocking = true
		time_since_block = 0
	if(Input.is_action_just_released("Block")):
		$AnimationPlayer.play_backwards("Block")
		blocking = false

func _draw():
	if(blocking):
		draw_arc(Vector2.ZERO, 50, -PI/4 - PI/8, -3*PI/4 - PI/8, 20, Color.WHITE, 5)

func _dash_check():
	if clicked != "" :
		timer -= 1
		if timer <= 0:
			clicked = ""
	if(Input.is_action_just_pressed("down")):
		timer = 120
		if(clicked == ""):
			clicked = "s"
		elif(clicked == "s"):
			_dash(Vector2(0, 1))
		else:
			clicked = ""
	if(Input.is_action_just_pressed("up")):
		timer = 120
		if(clicked == ""):
			clicked = "w"
		elif(clicked == "w"):
			_dash(Vector2(0, -1))
		else:
			clicked = ""
	if(Input.is_action_just_pressed("left")):
		timer = 120
		if(clicked == ""):
			clicked = "a"
		elif(clicked == "a"):
			_dash(Vector2(-1, 0))
		else:
			clicked = ""
	if(Input.is_action_just_pressed("right")):
		timer = 120
		if(clicked == ""):
			clicked = "d"
		elif(clicked == "d"):
			_dash(Vector2(1, 0))
		else:
			clicked = ""

func _dash(dir):
	velocity = dir * DASHSPEED
	dashing = true
	$DashingTimer.start(DASHTIME)
	clicked = ""
	timer = 60

func _switchingWeapons():
	if Input.is_action_pressed("SwitchWeapons"):
		$CanvasLayer/Background.visible = true
		switchingWeapons = true
		Global.pause = true
	else:
		if(switchingWeapons):
			if($WeaponSlot.get_children().size() > 0):
				$WeaponSlot.get_child(0).queue_free()
				can_attack = true
			if($CanvasLayer/Background/SelectionWheel.selectedNum < weapons.size()):
				var weapon = WeaponsScenes[weapons[$CanvasLayer/Background/SelectionWheel.selectedNum]].instantiate()
				weapon.leftArm = $Art/LArm
				weapon.rightArm = $Art/RArm
				$WeaponSlot.add_child(weapon)
				can_attack = !weapon.fistLock
			switchingWeapons = false
			Global.pause = false
		$CanvasLayer/Background.visible = false

func _attack():
	if !$AnimationPlayer.is_playing() and Input.is_action_just_pressed("Hit"):
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
			shockwave.energy = min(stored_energy, 1)
			stored_energy -= min(stored_energy, 1)
			$CanvasLayer/EnergyBar.size.x = stored_energy*100
			shockwave.damage = 1
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

func _checkWeapons():
	for i in weapons:
		$CanvasLayer/Background/SelectionWheel.sprites.append(WeaponsSprite[i])
	$CanvasLayer/Background/SelectionWheel._checkWeapons()

func _hit(hitbox):
	var dmg = hitbox.damage * (256 - global_position.distance_to(hitbox.sender.global_position))/256
	if(!blocking):
		pass
	else:
		stored_energy += (dmg - dmg*time_since_block)
		$CanvasLayer/EnergyBar.size.x = stored_energy * 100.0
		blocking = false

func _on_dashing_timer_timeout():
	dashing = false
