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
@export var MAXHEALTH : float
@export var MAXMANA : float
@export var BARSPEED : float
@export var HPBARMULT : float
@export var ENERGYBARMULT : float
@export var DASHCD : float : set = set_dash_cd
@export var BLOCKCD : float : set = set_block_cd
@export_group("Effects")
@export var Shockwave : PackedScene
@export var Afterimage : PackedScene
@export var HurtBackground : Node2D

@onready var Blast = preload("res://Magic/MagicCasts/Blast.tscn")
@onready var Explosion = preload("res://Magic/MagicCasts/Explosion.tscn")
@onready var PerfectBlock = preload("res://Effects/PerfectBlock.tscn")
@onready var GoodBlock = preload("res://Effects/GoodBlock.tscn")
@onready var BadBlock = preload("res://Effects/BadBlock.tscn")
@onready var EffectUI = preload("res://World/UI/EffectUI.tscn")
@onready var MagicNameCallout = preload("res://Magic/MagicCasts/MagicNameCallout.tscn")

var base_top_speed = 0.0
var type = 0
var rng = RandomNumberGenerator.new()
var clicked = ""
var timer = 120
var dashing = false
var blocking = false
var time = 0
var stored_energy = 50.0 : set = _energy_change
var mana = 0.0#display energy
var dmgTaken = 0
var time_last_block = -1
var time_last_hit = 0
var health = 0.0 : set = _health_change
var hp = 0.0#display hp
var healing = 1.0
var bonusHealBlock = false
var slow = false
var rotation_speed = 0
var onLastTurn = false
var effects = []
var vfx = []
var casting = false
var pause = false
#var charging = false
var hitbox = null
var hitboxEffects = []
var effectsHaventChecked = []
var intel = 1.0
var wisdom = 1.0
var comprehension = 1.0
var spellHit = null
var blockCharges = 1
var blockTimer = 2
var dashCharges = 1
var dashTimer = 2
var maxBlockCharges = 2.25
var maxDashCharges = 2.5

func _ready():
	#updateEnergy()
	$PlayerArt.hit.connect(_shockwave)
	rotation_speed = ROTATIONSPEED
	health = MAXHEALTH
	stored_energy = MAXMANA/10
	base_top_speed = TOPSPEED
	get_tree().current_scene.damageHealed = 0

func _process(delta):
	print(1/delta)
	#updateHealth()
	updateMaxHealth()
	updateMaxEnergy()
	#updateEnergy()
	#blockTimer -= delta
	time += delta
	queue_redraw()
	if((!Global.isPaused() and !pause) and !dashing):
		_blockCharging(delta)
		_dashCharging(delta)
		if(hp != health * HPBARMULT):
			updateHP(delta)
		if(mana != stored_energy * ENERGYBARMULT):
			updateMana(delta)
		_heal(delta)
		_effectsHandle(delta)
		magic_check(delta)
		rotateToTarget(get_global_mouse_position(), delta)
		_movement(delta)
		_friction(delta)
		attack()
		dash_check(delta)
		block()
	elif pause and !Global.isPaused():
		_effectsHandle(delta)
		_friction(delta)
	if(dashing):
		var after = Afterimage.instantiate()
		after.global_position = global_position
		after.rotation_degrees = rotation_degrees
		get_tree().current_scene.add_child(after)
	if(!Global.isPaused()): move_and_slide()

func set_dash_cd(f: float):
	DASHCD = f
	$CanvasLayer/TextureProgressBar2.max_value = DASHCD

func set_block_cd(f: float):
	BLOCKCD = f
	print(BLOCKCD)
	$CanvasLayer/TextureProgressBar.max_value = BLOCKCD


func _blockCharging(delta):
	$CanvasLayer/Label.text = str(blockCharges)
	$CanvasLayer/TextureProgressBar.value = blockTimer
	if(blockTimer <= 0):
		blockTimer += BLOCKCD
		blockCharges += 1
		print(str(blockCharges) + "charges")
	elif(blockCharges < maxBlockCharges and blockTimer > 0):
		blockTimer -= delta

func _dashCharging(delta):
	$CanvasLayer/Label2.text = str(dashCharges)
	$CanvasLayer/TextureProgressBar2.value = dashTimer
	if(dashTimer <= 0):
		dashTimer += DASHCD
		dashCharges += 1
		print(str(dashCharges) + "charges")
	elif(dashCharges < maxDashCharges and dashTimer > 0):
		dashTimer -= delta

func _health_change(newHP: float):
	var change = newHP - health
	if(change > 0):
		if(!bonusHealBlock):
			change *= healing
		while(change/pow(2,floor(health/MAXHEALTH)) > MAXHEALTH * floor(health/MAXHEALTH + 1) - health):
			var chamt = MAXHEALTH * floor(health/MAXHEALTH + 1) - health
			change -= chamt * pow(2,floor(health/MAXHEALTH))
			health += chamt
			get_tree().current_scene.damageHealed += chamt
		change = change/pow(2,floor(health/MAXHEALTH))
		health += change
		get_tree().current_scene.damageHealed += change
	elif(change < 0):
		health += change
		get_tree().current_scene.damageTaken -= change
		if(health < 0):
			get_tree().current_scene.death()
			Global.unPause()
	$CanvasLayer/ActualHealthBar.size.x = min(health * HPBARMULT, MAXHEALTH * HPBARMULT)
	$CanvasLayer/HealthBar3.size.x = health * HPBARMULT

func _energy_change(newMANA: float):
	var change = newMANA - stored_energy
	if(change > 0):
		while(change/pow(2,floor(stored_energy/MAXMANA)) > MAXMANA * floor(stored_energy/MAXMANA + 1) - stored_energy):
			var chamt = MAXMANA * floor(stored_energy/MAXMANA + 1) - stored_energy
			change -= chamt * pow(2,floor(stored_energy/MAXMANA))
			stored_energy += chamt
			get_tree().current_scene.damageHealed += chamt
		stored_energy += change/pow(2,floor(stored_energy/MAXHEALTH))
	elif(change < 0):
		stored_energy += change
		if(stored_energy < 0):
			stored_energy = 0
	$CanvasLayer/ActualEnergyBar.size.x = min(stored_energy * 5, MAXMANA*ENERGYBARMULT)


func block():
	if(Input.is_action_just_pressed("Block") and blockCharges > 0):
			$PlayerArt._block()
			blocking = true
			time_last_block = time
			blockCharges -= 1
	if(Input.is_action_just_released("Block") and blocking):
		$PlayerArt._unblock()
		blocking = false

func _draw():
	if(blocking):
		draw_arc(Vector2.ZERO, 50, 0, 2 * PI, 20, Color.WHITE, 5)

func _heal(delta):
	if(Input.is_action_pressed("Heal") and stored_energy > delta):
		var v = healing / (log(velocity.length_squared()/1) + 1)
		if(velocity.length_squared() < 10):
			v = healing
		stored_energy -= delta * 30 * v
		health += 5 * delta * v
		#get_tree().current_scene.damageHealed += MAXHEALTH * delta/2.5

func updateEnergy():
	$CanvasLayer/EnergyBar.size.x = min(mana * 5, MAXMANA*ENERGYBARMULT)
	if(mana * 5 > MAXMANA*ENERGYBARMULT):
		$CanvasLayer/EnergyBar3.size.x = mana - MAXMANA*ENERGYBARMULT/5
	else:
		$CanvasLayer/EnergyBar3.size.x = 0

func magic_check(delta):
	var hit = false
	for e:Spell in Global.spellList:
		if(!e.using):
			e.cooldown -= delta
		if e.binding != null and e.type != null:
			if Input.is_key_pressed(e.binding):
				hit = true
			if Input.is_key_pressed(e.binding) and !onLastTurn and e.cooldown < 0 and !casting and stored_energy >= e.initCost():
				var blast = e._cast(self)
				get_tree().current_scene.spellsCasted += 1
				ROTATIONSPEED /= 2
				stored_energy -= e.initCost()
				slow = blast.slow
				e.resetCooldown(true,pow(0.95,comprehension))
				#updateEnergy()
	onLastTurn = hit

func dash_check(delta):
	if(Input.is_action_pressed("Dash")):
		var input_vector = Vector2.ZERO
		input_vector.y = Input.get_axis("up", "down")
		input_vector.x = Input.get_axis("left", "right")
		input_vector = input_vector.normalized()
		dash(input_vector)
	elif(InputMap.action_get_events("Dash").size() == 0):
		_doubleClickCheck(delta)

func _doubleClickCheck(delta):
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
			timer = 0.25
	if clicked != "" :
		timer -= delta
		if timer <= 0:
			clicked = ""

func dash(dir):
	if(dashCharges > 0):#canDash()):
		velocity = dir * DASHSPEED
		dashing = true
		$DashingTimer.start(DASHTIME)
		clicked = ""
		blocking = false
		$PlayerArt._unblock()
		#attachEffect(Dash.new(1), false)
		dashCharges -= 1

func _shockwave():
	var shockwave = Shockwave.instantiate()
	shockwave.global_position = global_position
	shockwave.rotation_degrees = rotation_degrees
	shockwave.sender = self
	shockwave.energy = 1
	#updateEnergy()
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

func _effectsHandle(delta):
	for e in effects:
		e._tick(self, delta)

func _friction(delta):
	velocity *= pow(FRICTION,delta)

func _movement(delta):
	var newVel = velocity
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_axis("up", "down")
	input_vector.x = Input.get_axis("left", "right")
	input_vector = input_vector.normalized()
	newVel += input_vector * ACCELERATION * delta
	if(!blocking and !slow):
		newVel = newVel.limit_length(TOPSPEED)
	else:
		newVel = newVel.limit_length(TOPSPEED/2)
	
	velocity = newVel

func canDash():
	for e in effects:
		if(e is Dash):
			return false
	return true

func _hit(hitbox):
	self.hitbox = hitbox.clone()
	dmgTaken = hitbox.damageTaken(self)
	spellHit = hitbox.spell
	time_last_hit = time
	$HitRegister.start(0.06125)
	#_hit_register()

func _dmgRed(time):
	var mod = 1.5
	
	if(time < 0 and time > -0.02085 * mod):
		var perfectBlock = PerfectBlock.instantiate()
		perfectBlock.global_position = hitbox.global_position
		get_tree().current_scene.add_child(perfectBlock)
		#blockTimer = 0.1
		effectsHaventChecked = []
		blockTimer -= BLOCKCD*0.5
		get_tree().current_scene.perfectBlocks += 1
		return 1
	if(time < -0.02085 * mod and time > -0.04165 * mod):
		var goodBlock = GoodBlock.instantiate()
		goodBlock.global_position = hitbox.global_position
		get_tree().current_scene.add_child(goodBlock)
		#blockTimer = 0.1
		effectsHaventChecked = []
		get_tree().current_scene.goodBlocks += 1
		return (((0.0833 - abs(time/mod)*2)/(0.0416)) * 0.15) + 0.85
	if(time < -0.04165 * mod and time > -0.06125 * mod):
		var badBlock = BadBlock.instantiate()
		badBlock.global_position = hitbox.global_position
		get_tree().current_scene.add_child(badBlock)
		get_tree().current_scene.badBlocks += 1
		return (-13.68 + 3.173*(abs(time/mod)*200) + 0.02387*pow((abs(time/mod)*200), 2))/100.0
	if(time > 0 and time < 0.0417 * mod):
		var perfectBlock = PerfectBlock.instantiate()
		perfectBlock.global_position = hitbox.global_position
		get_tree().current_scene.add_child(perfectBlock)
		#blockTimer = 0.1
		effectsHaventChecked = []
		blockTimer -= BLOCKCD*0.5
		get_tree().current_scene.perfectBlocks += 1
		return 1
	if(time > 0.0417 * mod and time < 0.0833 * mod):
		var goodBlock = GoodBlock.instantiate()
		goodBlock.global_position = hitbox.global_position
		get_tree().current_scene.add_child(goodBlock)
		#blockTimer = 0.1
		effectsHaventChecked = []
		get_tree().current_scene.goodBlocks += 1
		return (((0.0833 - time/mod)/(0.0416)) * 0.15) + 0.85
	if(time > 0.0833 * mod and time < 0.125 * mod):
		var badBlock = BadBlock.instantiate()
		badBlock.global_position = hitbox.global_position
		get_tree().current_scene.add_child(badBlock)
		get_tree().current_scene.badBlocks += 1
		return (-13.68 + 3.173*(time/mod*100) + 0.02387*pow((time/mod*100), 2))/100.0
	get_tree().current_scene.noBlocks += 1
	return 0
	
func doneCasting():
	#charging = false
	slow = false
	ROTATIONSPEED *= 2
	casting = false

func _on_dashing_timer_timeout():
	dashing = false

func _hit_register():
	var dmgRed = _dmgRed(abs(time_last_hit-time_last_block))
	processHaventChecked()
	for i in spellHit.components:
		i.callBlockEffects(dmgRed, hitbox, self)
	effectsHaventChecked = []
	#print("timeDiff: " + str(abs(time_last_hit-time_last_block)))
	#print("damage: " + str(dmgTaken * (1-dmgRed)))
	#print("dmg Reduction: " + str(dmgTaken - dmgTaken * (1-dmgRed)))
	#print("stored Energy increase: " + str(dmgTaken * (dmgRed)))
	#stored_energy += dmgTaken * dmgRed * 10 * wisdom
	stored_energy += spellHit.initCost() * dmgRed * 2 * wisdom
	get_tree().current_scene.damageBlocked += dmgTaken * dmgRed
	health -= dmgTaken * (1-dmgRed)
	#updateEnergy()
	#$CanvasLayer/HealthBar.size.x = health*20.0
	#updateHealth()
	time = 0
	time_last_block = -1

func updateMana(delta):
	var bar_energy = stored_energy * ENERGYBARMULT
	if(mana < bar_energy):
		mana += maxf(BARSPEED / 100 * MAXMANA * ENERGYBARMULT * delta,abs(mana - bar_energy) * delta)
		if(mana > bar_energy):
			mana = bar_energy
	else:
		mana -= maxf(BARSPEED / 100 * MAXMANA * ENERGYBARMULT * delta,abs(mana - bar_energy) * delta)
		if(mana < bar_energy):
			mana = bar_energy
	updateEnergy()

func updateHealth():
	$CanvasLayer/HealthBar.size.x = hp
	HurtBackground._update(health)

func updateHP(delta):
	var bar_health = health * HPBARMULT
	if(hp < bar_health):
		hp += maxf(BARSPEED / 100 * MAXHEALTH * HPBARMULT * delta,abs(hp - bar_health)  * delta)
		if(hp > bar_health):
			hp = bar_health
	else:
		hp -= maxf(BARSPEED / 100 * MAXHEALTH * HPBARMULT * delta,abs(hp - bar_health)  * delta)
		if(hp < bar_health):
			hp = bar_health
	updateHealth()

func updateMaxHealth():
	$CanvasLayer/HealthBar2.size.x = MAXHEALTH*HPBARMULT

func updateMaxEnergy():
	$CanvasLayer/EnergyBar2.size.x = MAXMANA*ENERGYBARMULT

func attachEffect(effect, needsChecking=true):
	if needsChecking:
		effectsHaventChecked.append(effect)
	else:
		var visual = effect.visual.instantiate()
		add_child(visual)
		vfx.append(visual)
		effects.append(effect)
		var effectUI = EffectUI.instantiate()
		effectUI.initialize(effect)
		$CanvasLayer/ScrollContainer/HBoxContainer.add_child(effectUI)

func processHaventChecked():
	for e in effectsHaventChecked:
		var visual = e.visual.instantiate()
		add_child(visual)
		vfx.append(visual)
		effects.append(e)
		var effectUI = EffectUI.instantiate()
		effectUI.initialize(e)
		$CanvasLayer/ScrollContainer/HBoxContainer.add_child(effectUI)

func removeEffects(effect):
	for b in effects:
		if(b.effectName == effect.effectName):
			b._tick(self, 1000000)
			break

func _on_hit_register_timeout():
	_hit_register()
