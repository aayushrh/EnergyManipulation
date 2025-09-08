extends CharacterBody2D
class_name BasicEnemy

var player : Player = null
var cooldown : float = 5
var can_attack : bool = true
var slow : bool = false
var effects : Array = []
var vfx : Array = []
var nomove: bool = false
var dmgTaken : float = 0
var time : float = 0
var block : float = -1
var blocking : bool = false
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var detectMagic : Array = []
var magic : Array = []#player casted spell
var spells : Array = []# enemy casted spells
var castedIndex : int = -1
var canDash : bool = true
var type : int = 1
var nomoveinput : bool = false
var wisdom : float = 1.0
var fuck : bool = false # fuck nature
var dodgeDir : int = 0
var moveDir : float = 0.0
var blast = null
var casting : bool = false
var healing : float = 1.0
var bonusHealBlock : bool = false
var MAXHEALTH : float = 0
var MAXMANA : float = 100.0 : set = _max_mana_change
var agg : bool = false#(randi_range(0,1)==0)
var pause : bool = false
var stored_energy : float = MAXMANA : set = _energy_change
var mana : float = stored_energy
var blinded : bool = false
var reactionDelay : float = 0.0
var intel : float = 1
var hp : float = 0.0
var stage : int = 0
var delt : float = 0
var prediction : bool = false
var healthbar = null
var chargeTime : float = 0
var currentDamageNum = null

@export var HPBARMULT : float = 80.0
@export var BARSPEED : float = 20.0
@export var health : float = 0.0 : set = _health_change
@export var checkAngle : float = 45 # angle checked for things that will be going towards them
@export var blockOrFlight : int = 2 # how many will have to be going for it to block
@export var tact : float = 100 - int(agg)*75 # chance to do smarter things
@export var DASHSPEED : float = 2500
@export var cooldownAttack : float = 1.0
@export var TOPSPEED : float = 200
@export var ROTATIONSPEED : float = 10
@export var Shockwave : PackedScene
@export var dash_cd : float = 5
@export var dash_time : float = 0.1
@export var block_cd : float = 1.0
@export var caution_range : float = 300
@export var min_range : float = 300 - 50*int(agg)
@export var max_range : float = 500 - 50*int(agg)

@export var art : Node2D
@export var softBody : Area2D

@onready var BlastTscn = preload("res://Magic/MagicCasts/Blast.tscn")
@onready var Explosion = preload("res://Magic/MagicCasts/Explosion.tscn")
@onready var HealthBar = preload("res://enemy_health.tscn")
@onready var DamageNum = preload("res://Effects/DamageNum.tscn")

func _ready():
	art.finishCharge.connect(_finishCharge)
	rng.randomize()
	var num = rng.randi_range(0, 9)
	rng.randomize()
	var spell = Spell.new("firstSpell" + str(rng.randf_range(0, 1)))
	spell.type = get_tree().current_scene.allTypeSpellCards[rng.randi_range(0, get_tree().current_scene.allTypeSpellCards.size() - 1)]
	while true:
		var comp = get_tree().current_scene.allComponentSpellCards[rng.randi_range(0, get_tree().current_scene.allComponentSpellCards.size() - 1)]
		spell.components.append(comp)
		if comp.isElement:
			break
		
	var s = float(stage)
	healthbar = HealthBar.instantiate()
	healthbar.myParent = self
	get_tree().current_scene.add_child(healthbar)
	var spellcount = 0
	match num:
		0, 1, 2, 3: #Dashing dude
			agg = true
			dash_cd = 2.5 / pow(1.05,s)
			MAXHEALTH = 2 + s/15.0
			intel = 0.5 + s/30.0
			reactionDelay = randf_range(0.105,0.150)
			wisdom = 1 + s/40
			spellcount += floor(s/6)
		4, 5, 6: #Power dude
			agg = rng.randi_range(0, 1) == 0
			dash_cd = 5 / pow(1.03, s)
			MAXHEALTH = 2 + s/10.0
			intel = 1 + s/10.0
			reactionDelay = randf_range(0.15,0.25)
			wisdom = 0.5 + s/100
			spellcount += floor(s/10)
			#spell.style = get_tree().current_scene.allStyleSpellCards[0]
		7, 8: #Healthy dude
			agg = rng.randi_range(0, 1) == 0
			dash_cd = 5
			MAXHEALTH = 4 + s / 2.0
			intel = 0.75 + s/25.0
			reactionDelay = randf_range(0.35,0.45)
			wisdom = 1 + s/100
			spellcount += floor(s/8)
		9: # Wisdom dude
			agg = false
			dash_cd = 5
			MAXHEALTH = 2 + s/5.0
			intel = 0.75 + s/20.0
			reactionDelay = randf_range(0.175,0.200)
			wisdom = 2 + s/2
			spellcount += floor(s/3)
	
	stored_energy *= wisdom
	MAXMANA *= wisdom
	rng.randomize()
	for i in range(spellcount):
		var spell2 = Spell.new("Spell Number " + str(i)  + str(rng.randf_range(0, 1)))
		spell2.type = get_tree().current_scene.allTypeSpellCards[rng.randi_range(0, get_tree().current_scene.allTypeSpellCards.size() - 1)]
		var isElement = false
		while(!isElement):
			var newCard = get_tree().current_scene.allComponentSpellCards[rng.randi_range(0, get_tree().current_scene.allComponentSpellCards.size() - 1)]
			isElement = newCard.isElement
			spell2.components.append(newCard)
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
	health = MAXHEALTH

func _finishCharge():
	slow = false
	ROTATIONSPEED *= 2

#func _init(stag):
#	stage = stag

func _physics_process(delta):
	delta *= Global.getTimeScale()
	delt = delta
	#if blinded:
		#$Area2D.monitoring = false
	#else:
		#$Area2D.monitoring = true
		
	if(!Global.isPaused() and !pause):
		detectMagic = detectMagic.filter(runDelay)
		if(health != hp):
			updateHP(delta)
		if(mana != stored_energy):
			updateMana(delta)
		queue_redraw()
		time+=delta
		magic_check(delta)
		_effectsHandle(delta)
		if(stored_energy == 0 && blast):
			blast.letGo()
			blast = null
			castedIndex = -1
		if(blast == null and (stored_energy < MAXMANA/4 or stored_energy < spells[0].initCost() or $Charging.emitting)):
			energyGain(delta)
		if(!nomove):
			_move(delta)
		move_and_slide()
	if(!Global.isPaused and pause):
		_effectsHandle(delta)

func _max_mana_change(newMax: float):
	healthbar.update_maxMana(newMax)
	MAXMANA = newMax

func _health_change(newHP: float):
	var change = newHP - health
	if(change > 0):
		if(!bonusHealBlock):
			change = change * healing
		while(change/pow(2,floor(health/MAXHEALTH)) > MAXHEALTH * floor(health/MAXHEALTH + 1) - health):
			var chamt = MAXHEALTH * floor(health/MAXHEALTH + 1) - health
			change -= chamt * pow(2,floor(health/MAXHEALTH))
			health += chamt
			get_tree().current_scene.damageHealed += chamt
		change = change/pow(2,floor(health/MAXHEALTH))
		health += change
	elif(change < 0):
		health += change
		if (get_tree()!=null):
			if(!fuck):
				get_tree().current_scene.damageDealt -= change
			if(health <= 0):
				$EnemyArt._kill()
				pause = true
				#queue_free()
				get_tree().current_scene.enemiesKilled += 1
		if is_instance_valid(currentDamageNum):
			currentDamageNum.global_position = global_position + Vector2(50, -50)
			currentDamageNum._display(change, false)
		else:
			var damageNum = DamageNum.instantiate()
			damageNum.global_position = global_position + Vector2(50, -50)
			damageNum._displayNum(change, false)
			get_tree().current_scene.add_child(damageNum)
			currentDamageNum = damageNum
	healthbar.get_actual_health().size.x = min((health * HPBARMULT)/(MAXHEALTH*1.0),HPBARMULT)
	healthbar.get_over_health().size.x = (health * HPBARMULT)/(MAXHEALTH*1.0)
	fuck = false

func _energy_change(newMANA: float):
	var change = newMANA - stored_energy
	if(change > 0):
		while(change/pow(2,floor(stored_energy/MAXMANA)) > MAXMANA * floor(stored_energy/MAXMANA + 1) - stored_energy):
			var chamt = MAXMANA * floor(stored_energy/MAXMANA + 1) - stored_energy
			change -= chamt * pow(2,floor(stored_energy/MAXMANA))
			stored_energy += chamt
			get_tree().current_scene.damageHealed += chamt
		stored_energy += change/pow(2,floor(stored_energy/MAXMANA))
	elif(change < 0):
		stored_energy += change
		if(stored_energy < 0):
			stored_energy = 0
	healthbar.set_energy(stored_energy)

func updateMana(delta):
	var bar_energy = stored_energy
	if(mana < bar_energy):
		mana += maxf(BARSPEED / 100 * MAXMANA * delta,abs(mana - bar_energy) * delta)
		if(mana > bar_energy):
			mana = bar_energy
	else:
		mana -= maxf(BARSPEED / 100 * MAXMANA * delta,abs(mana - bar_energy) * delta)
		if(mana < bar_energy):
			mana = bar_energy
	updateEnergy()

func updateEnergy():
	healthbar.get_animation_energy().value = mana

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

func updateHealth():
	healthbar.get_animation_health().size.x = (hp * 1.0)/(MAXHEALTH*1.0)

func _effectsHandle(delta):
	for e in effects:
		e._tick(self, delta)

func _hit(hitbox):
	dmgTaken = hitbox.damageTaken()
	if(block>0):
		health -= dmgTaken*(1-_dmgRed(time-block))
		un_block()
	else:
		for i in hitbox.spell.components:
			i.callBlockEffects(0, hitbox, self)
		health -= dmgTaken
	time = 0

func _move(delta):
	velocity *= pow(0.9,delta*120)
	
	var softBodyPush = $SoftBody.getVector()
	
	cooldown -= delta
	if(cooldown <=0):
		can_attack = true
	if player != null:
		if(castedIndex != -1 and spells[castedIndex].type.aimType == 0):
			if(prediction):
				rotateToTarget(player.global_position, delta)
				if(blast != null and is_instance_valid(blast) and (blast.chargeTimer <= 0 or global_position.distance_to(player.global_position)<300)):
					blast.letGo()
					blast = null
					castedIndex = -1
			else:
				predictionrotate(player, delta)
		else:
			rotateToTarget(player.global_position, delta)
			
		var inputV = Vector2.ZERO
		
		if((player.global_position - global_position).length() > max_range + caution_range * int(!agg and player.casting)):
			inputV = (player.global_position - global_position).normalized()
		elif((player.global_position - global_position).length() < min_range + caution_range * int(!agg and player.casting)):
			inputV = (player.global_position - global_position).normalized() * -1
		if(!nomoveinput and !$Charging.emitting):
			velocity += inputV * 20
		
		#if velocity.length() > TOPSPEED:
			#velocity = velocity.normalized() * TOPSPEED
		
		#if((player.global_position - global_position).length() > max_range + caution_range * int(!agg and player.casting)):
			#velocity = (player.global_position - global_position).normalized() * TOPSPEED
		#elif((player.global_position - global_position).length() < min_range + caution_range * int(!agg and player.casting)):
			#velocity = (player.global_position - global_position).normalized() * -TOPSPEED
		#else:
			#pass
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
			if(blast != null and is_instance_valid(blast) and ((!canDash and !nomove) or global_position.distance_to(player.global_position)<300)):
				blast.letGo()
				blast = null
				castedIndex = -1
		velocity -= softBodyPush * TOPSPEED
		velocity *= Global.getTimeScale()
		if(slow):
			velocity = velocity * 0.5

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	var angleTo = transform.x.angle_to(direction) + PI/2
	rotate(sign(angleTo) * min(delta * ROTATIONSPEED, abs(angleTo)))

func _punch():
	art._startPunch()

func _on_vision_body_entered(body):
	if!(body is Wall):
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
			if(dodgeDir == 0 and e.cooldown < 0 and !casting and stored_energy > e.initCost() and !$Charging.emitting):
				blast = e._cast(self)
				prediction = tactCheck(50)
				stored_energy -= e.initCost()
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

func energyGain(delta):
	$Charging.emitting = stored_energy < MAXMANA

	stored_energy += delta * wisdom * 0.05 * pow(chargeTime,2)
	chargeTime += delta
	if(!$Charging.emitting):
		chargeTime = 0

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
			pass
			'''if(block == -1):
				if(canDash):
					dash(avgDir(help))
					"if(tactCheck(100) and is_this_thing_too_close_to_me((global_position-n.global_position-n.v).angle(),n.v,DASHSPEED)):
						do_block()
					else:
						dash(avgDir(help))"
				else:
					"if(tactCheck(100) and is_this_thing_too_close_to_me((global_position-n.global_position-n.v).angle(),n.v,TOPSPEED)):
						do_block()
					else:
						velocity = avgDir(help) * TOPSPEED"
					velocity = avgDir(help) * TOPSPEED'''
		elif(block == -1):
			if(canDash):
				dash(perp_vector(avgDir(help)))
			else:
				if(dodgeDir == 0):
					#if(tactCheck(20)):
						dodgeDir = int((avgDir(help)-avgVelo(help)).angle()>0)*2-1
					#else:
					#	dodgeDir = rng.randi_range(0,1)*2-1
				#velocity = Vector2.ZERO
				velocity += set_perp_vector(avgDir(help),dodgeDir>0).normalized()# * TOPSPEED
	#if(help.size() == 0 and player != null and player.casting):
	#	velocity = (player.global_position - global_position).normalized() * -TOPSPEED

func searchLight():
	var i = 0
	for e in effects:
		if e is LightBlindness:
			return i
		i += 1
	return - 1

func searchDark():
	var i = 0
	for e in effects:
		if e is DarkBlindness:
			return i
		i += 1
	return - 1

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
	velocity = Vector2.ZERO

func getIntel():
	if searchDark() != -1:
		return (intel * pow(.95,effects[searchDark()].stack))
	return intel

func attachEffect(effect, check = true):
	if effect.enemyShows:
		var visual = effect.visual.instantiate()
		add_child(visual)
		vfx.append(visual)
	effects.append(effect)
