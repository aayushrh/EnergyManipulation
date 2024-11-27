extends CharacterBody2D
class_name BasicEnemy

var player = null
var cooldown = 5
var can_attack = true
var slow = false
var effects = []
var vfx = []
var nomove = false
var dmgTaken = 0
var time = 0
var block = -1
var blocking = false
var rng = RandomNumberGenerator.new()
var detectMagic = []
var magic = []#player casted spell
var spells = []# enemy casted spells
var castedIndex = -1
var canDash = true
var type = 1
var dodgeDir = 0
var moveDir = 0.0
var blast = null
var casting = false
var maxHealth = 0
var agg = false#(randi_range(0,1)==0)
var pause = false
var stored_energy = 0
var blinded = false
var reactionDelay = 0.0
var intel = 1
var hp = 0.0
var stage = 0
var delt = 0

@export var HPBARMULT = 80.0
@export var BARSPEED = 20.0
@export var health = 5.0 : set = _health_change
@export var checkAngle = 45 # angle checked for things that will be going towards them
@export var blockOrFlight = 2 # how many will have to be going for it to block
@export var tact = 0 # chance to do smarter things
@export var DASHSPEED = 5000
@export var cooldownAttack = 1.0
@export var TOPSPEED = 200
@export var ROTATIONSPEED = 10
@export var Shockwave : PackedScene
@export var dash_cd = 5
@export var dash_time = 0.1
@export var block_cd = 1.0
@export var caution_range = 300
@export var min_range = 300 - 50*int(agg)
@export var max_range = 500 - 50*int(agg)

@export var art : Node2D
@export var softBody : Area2D

@onready var BlastTscn = preload("res://Magic/MagicCasts/Blast.tscn")
@onready var Explosion = preload("res://Magic/MagicCasts/Explosion.tscn")


func _ready():
	print(stage)
	art.finishCharge.connect(_finishCharge)
	art.hit.connect(_shockwave)
	rng.randomize()
	var num = rng.randi_range(0, 9)
	rng.randomize()
	var spell = Spell.new("firstSpell")
	spell.type = get_tree().current_scene.allTypeSpellCards[rng.randi_range(0, get_tree().current_scene.allTypeSpellCards.size() - 1)]
	spell.element = get_tree().current_scene.allElementSpellCards[rng.randi_range(0, get_tree().current_scene.allElementSpellCards.size() - 1)]
	match num:
		0, 1, 2, 3: #Dashing dude
			agg = true
			dash_cd = 2.5 / pow(1.05,stage)
			maxHealth = 2 + stage/10
			intel = 0.8 + stage/10
			reactionDelay = randf_range(0.025,0.1)
			rng.randomize()
			spell.attributes = Attributes.new(rng.randf_range(-10, 10), rng.randf_range(-50,0),1)
			spell.style = get_tree().current_scene.allStyleSpellCards[1]
			#TOPSPEED *= 2
		4, 5, 6: #Power dude
			agg = rng.randi_range(0, 1) == 0
			dash_cd = 5
			maxHealth = 2 + stage/5
			intel = 1 + stage/2.5
			reactionDelay = randf_range(0.1,0.2)
			rng.randomize()
			spell.attributes = Attributes.new(rng.randf_range(-10, 10), rng.randf_range(0, 50), 1)
			#spell.style = get_tree().current_scene.allStyleSpellCards[0]
		7, 8: #Healthy dude
			agg = rng.randi_range(0, 1) == 0
			dash_cd = 5
			maxHealth = 4 + stage / 2
			intel = 0.75 + stage/15
			reactionDelay = randf_range(0.15,0.25)
			rng.randomize()
			spell.attributes = Attributes.new(rng.randf_range(0, 50), rng.randf_range(-10, 10), 1)
		9: # Wisdom dude
			agg = false
			dash_cd = 5
			maxHealth = 2 + stage/5
			intel = 0.75 + stage/10
			reactionDelay = randf_range(0.025,0.05)
			rng.randomize()
			for i in (int(floor(stage/5)) + 1):
				var spell2 = Spell.new("Spell Number " + str(i))
				spell2.type = get_tree().current_scene.allTypeSpellCards[rng.randi_range(0, get_tree().current_scene.allTypeSpellCards.size() - 1)]
				spell2.element = get_tree().current_scene.allElementSpellCards[rng.randi_range(0, get_tree().current_scene.allElementSpellCards.size() - 1)]
				spell.attributes = Attributes.new(rng.randf_range(-50, 0), rng.randf_range(-10, 10), 1)
				spell2.attributes = Attributes.new(rng.randf_range(-50, 0), rng.randf_range(-10, 10), 1)
				spells.append(spell2)
			
	#var spell = Spell.new("firstSpell")
	#spell.type = get_tree().current_scene.allTypeSpellCards[rng.randi_range(0, get_tree().current_scene.allTypeSpellCards.size() - 1)]
	#spell.style = get_tree().current_scene.allStyleSpellCards[rng.randi_range(0, get_tree().current_scene.allStyleSpellCards.size() - 1)]
	#spell.element = get_tree().current_scene.allElementSpellCards[rng.randi_range(0, get_tree().current_scene.allElementSpellCards.size() - 1)]
	var r = rng.randi_range(1,20)
	for i in range(19):
		r -= 20 + i
		if(r<0):
			r = i+1
			break
	#spell.attributes = Attributes.new(rng.randf_range(-50,50),rng.randf_range(-50,50),r)
	spells.append(spell)
	health = maxHealth
	print(health)

func _finishCharge():
	slow = false
	ROTATIONSPEED *= 2

#func _init(stag):
#	stage = stag

func _process(delta):
	delt = delta
	#if blinded:
		#$Area2D.monitoring = false
	#else:
		#$Area2D.monitoring = true
	if(!Global.isPaused() and !pause):
		detectMagic = detectMagic.filter(runDelay)
		if(health != hp):
			updateHP(delta)
		queue_redraw()
		time+=delta
		magic_check(delta)
		_effectsHandle(delta)
		if(!nomove):
			pass
			_move(delta)
		move_and_slide()
	if(!Global.isPaused and pause):
		_effectsHandle(delta)

func _health_change(newHP: float):
	var change = newHP - health
	if(change > 0):
		change = change/pow(2,int(health/maxHealth))
		health += change
	elif(change < 0):
		health += change
		if (get_tree()!=null):
			get_tree().current_scene.damageDealt -= change
			if(health <= 0):
				queue_free()
				get_tree().current_scene.enemiesKilled += 1
	$Health2.size.x = (health * HPBARMULT)/(maxHealth*1.0)


func updateHP(delta):
	var bar_health = health * HPBARMULT
	if(hp < bar_health):
		hp += maxf(BARSPEED / 100 * maxHealth * HPBARMULT * delta,abs(hp - bar_health)  * delta)
		if(hp > bar_health):
			hp = bar_health
	else:
		hp -= maxf(BARSPEED / 100 * maxHealth * HPBARMULT * delta,abs(hp - bar_health)  * delta)
		if(hp < bar_health):
			hp = bar_health
	updateHealth()

func updateHealth():
	$Health.size.x = (hp * 1.0)/(maxHealth*1.0)

func _effectsHandle(delta):
	for e in effects:
		e._tick(self, delta)

func _hit(hitbox):
	dmgTaken = hitbox.damageTaken(self)
	print(dmgTaken)
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
		if(castedIndex != -1 and spells[castedIndex].type.aimType == 0):
			if(agg):
				rotateToTarget(player.global_position, delta)
			else:
				predictionrotate(player, delta)
		else:
			rotateToTarget(player.global_position, delta)
		if((player.global_position - global_position).length() > max_range + caution_range * int(!agg and player.casting)):
			velocity = (player.global_position - global_position).normalized() * TOPSPEED
		elif((player.global_position - global_position).length() < min_range + caution_range * int(!agg and player.casting)):
			velocity = (player.global_position - global_position).normalized() * -TOPSPEED
		else:
			pass
			#if(moveDir == 0):
			#	moveDir = rng.randi_range(0,1)*2-1
			#elif(rng.randi_range(0,10000)==1):
			#	moveDir = -moveDir
			#else:
			#	moveDir = moveDir*pow(1.5,delta)
			#velocity = set_perp_vector((player.global_position - global_position).normalized(), moveDir>0) * TOPSPEED
		awareness(delta)
		if(agg):
			aggro(player, delta)
			if(blast != null and ((!canDash and !nomove) or global_position.distance_to(player.global_position)<100)):
				blast.letGo()
				blast = null
				castedIndex = -1
		velocity -= softBodyPush * TOPSPEED
		if(slow):
			velocity = velocity * 0.5

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	var angleTo = transform.x.angle_to(direction) + PI/2
	rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func _punch():
	art._startPunch()

func _on_vision_body_entered(body):
	player = body

func runDelay(arr):
	arr[1]-=delt
	if(arr[1]<=0):
		magic.append(arr[0])
		return false
	return true
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
	if(player!=null):
		var track = -1
		for e:Spell in spells:
			track += 1
			if(!e.using):
				e.cooldown -= delta
			if(dodgeDir == 0 and e.cooldown < 0 and !casting):
				blast = e._cast(self)
				castedIndex = track
				slow = true
				ROTATIONSPEED /= 2
				e.resetCooldown(true, 1)
				casting = true

func predictionrotate(player,delta):
	if(blast!=null):
		var a = pow(blast.getSpeed(),2)-player.velocity.distance_squared_to(Vector2.ZERO)
		var b = -2*(((player.global_position.x-global_position.x)*player.velocity.x)+((player.global_position.y-global_position.y)*player.velocity.y))
		var c = -(player.global_position-global_position).x-(player.global_position-global_position).y
		var time = (-b + sqrt(b * b - 4 * a * c))/(2 * a)
		if(time < 0):
			time = abs((-b - sqrt(b * b - 4 * a * c))/(2 * a))
		var v = player.global_position
		if(!is_nan(time)):
			v += player.velocity*time
		rotateToTarget(v,delta)
		if(blast.castingTimer<=0 and (int(abs(rotation + PI/2 - v.angle_to_point(global_position)))%3) < 0.1):#yay radians
			blast.letGo()
			blast = null
			castedIndex = -1
			#casting = false
	else:
		pass#for beam in the future not now lol

func doneCasting():
	slow = false
	ROTATIONSPEED *= 2
	casting = false

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
	velocity = dir*DASHSPEED
	nomove = true
	canDash = false
	$dashing.start(dash_time)
	$dash_cd.start(dash_cd+dash_time)

func do_block():
	pass
	#if(block==-1 and !nomove):
		#block = time
		#slow = true
		#$block_cd.start(block_cd)

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

func aggro(player, delta):
	if(blast != null):
		if(blast.castingTimer < 0):
			if(canDash):
				dash((player.global_position - global_position).normalized())


func awareness(delta):
	var help = []
	for n in magic:
		if(is_instance_valid(n) and n is Blast):
			var asdf = is_this_thing_going_towards_me((global_position-n.global_position).angle(),n.v)
			if(asdf):
				help.append(n)
	if(dodgeDir != 0 and help.size() <= 0):
		dodgeDir = 0
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
				if(dodgeDir == 0):
					#if(tactCheck(20)):
						dodgeDir = int((avgDir(help)-avgVelo(help)).angle()>0)*2-1
					#else:
					#	dodgeDir = rng.randi_range(0,1)*2-1
				velocity = set_perp_vector(avgDir(help),dodgeDir>0) * TOPSPEED
	#if(help.size() == 0 and player != null and player.casting):
	#	velocity = (player.global_position - global_position).normalized() * -TOPSPEED

func _on_block_cd_timeout() -> void:
	un_block()

func _on_dash_cd_timeout() -> void:
	canDash = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent() is Blast and is_instance_valid(area.get_parent().sender) and area.get_parent().sender.type != type):
		
		detectMagic.append([area.get_parent(),reactionDelay])
		#magic.append(area.get_parent())

func _on_area_2d_area_exited(area: Area2D) -> void:
	if(is_instance_valid(area.get_parent()) and area.get_parent() is Blast and is_instance_valid(area.get_parent().sender) and area.get_parent().sender.type != type):
		#magic.append(area.get_parent())
		pass

func _on_dashing_timeout() -> void:
	nomove = false

func attachEffect(effect):
	var visual = effect.visual.instantiate()
	add_child(visual)
	vfx.append(visual)
	effects.append(effect)
