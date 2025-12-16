extends CharacterBody2D
class_name BaseEnemy

var player : Player = null
var slow : bool = false
var effects : Array = []
var vfx : Array = []
var nomove: bool = false
var dmgTaken : float = 0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var nomoveinput : bool = false
var fuck : bool = false # fuck nature
var moveDir : float = 0.0
var healing : float = 1.0
var agg : bool = false
var pause : bool = false
var blinded : bool = false
var hp : float = 0.0
var stage : int = 0
var healthbar = null
var currentDamageNum = null
var dmgNum = {}
var type = 1
var speedModifier = 1
var health : float = 0.0 : set= _health_change
var overrideMove : bool = false
var test = false

@export_category("Health")
@export var HPBARMULT : float = 80.0
@export var BARSPEED : float = 20.0
@export var MAXHEALTH : float = 10.0

@export_category("Movement")
@export var TOPSPEED : float = 200
@export var ROTATIONSPEED : float = 10
@export var caution_range : float = 300
@export var min_range : float = 300 - 50*int(agg)
@export var max_range : float = 500 - 50*int(agg)

@export_category("Nodes")
@export var softBody : Area2D
@export var enemyArt : Node2D

@onready var HealthBar = preload("res://enemy_health.tscn")
@onready var DamageNum = preload("res://Effects/DamageNum.tscn")

func _ready():
	player = Global.player
	healthbar = HealthBar.instantiate()
	healthbar.myParent = self
	#add_child(healthbar)
	print("healthbar?")
	health = MAXHEALTH

func _physics_process(delta):
	if !test:
		get_tree().current_scene.add_child(healthbar)
		test = true
	if (player == null or !is_instance_valid(player)):
		player = Global.player
	delta *= Global.getTimeScale()
	if(!Global.isPaused() and !pause):
		if(health != hp):
			updateHP(delta)
		_effectsHandle(delta)
		if(!nomove and !overrideMove):
			_move(delta)
		move_and_slide()
	if(!Global.isPaused and pause):
		_effectsHandle(delta)

func _health_change(newHP: float):
	var change = newHP - health
	if(change > 0):
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
				enemyArt._kill()
				pause = true
				get_tree().current_scene.enemiesKilled += 1
		if is_instance_valid(currentDamageNum):
			currentDamageNum.update_pos(global_position)
			currentDamageNum._display(change)
	healthbar.get_actual_health().size.x = min((health * HPBARMULT)/(MAXHEALTH*1.0),HPBARMULT)
	healthbar.get_over_health().size.x = (health * HPBARMULT)/(MAXHEALTH*1.0)
	fuck = false
	
func commit_dmg(change: float, dict := {}):
	var c : Color
	var inc : Color
	var thing = ""
	var cng = 0
	var show = true
	var heal = false
	var type = "normal"
	if change < 0:
		c = Color(1, 0, 0)
	elif change == 0:
		return
	else:
		c = Color(0, 1, 0)
	if(dict):
		inc = dict["color"] if dict.has("color") else Color(1,1,1)
		heal = dict["heal"] if dict.has("heal") else false
		if(dict.has("crit")):
			thing += "!" * dict["crit"]
		show = not dict["hide"] if dict.has("hide") else true
		type = dict["type"] if dict.has("type") else "normal"
	if(type == "normal"):
		type = "damage" if change < 0 else "heal"
	var oh = health
	health += change * healing if change > 0 and heal else change
	cng = health - oh
	inc = Color(1,1,1) if not inc else inc
	if(show):
		display_dmg(cng, c, inc, type, thing)

func display_dmg(change: float, c: Color, inc := Color(1,1,1), type := "", thing := ""):
	if get_tree() != null:
		if (type == ""):
			type = "damage" if change < 0 else "heal"
		if dmgNum.has(type) and is_instance_valid(dmgNum[type]):
			dmgNum[type].update_pos(global_position)
			dmgNum[type]._display(change)
		else:
			var dn = DamageNum.instantiate()
			dn.create(c, inc)
			get_tree().current_scene.add_child.call_deferred(dn)
			dmgNum[type] = dn
			dmgNum[type]._display(change)
			dmgNum[type].update_pos(global_position)

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
	commit_dmg(-dmgTaken)

func _move(delta):
	velocity *= pow(0.9,delta*120)
	
	var softBodyPush = $SoftBody.getVector()
	
	if player != null:
		rotateToTarget(player.global_position, delta)
		var inputV = Vector2.ZERO
		if((player.global_position - global_position).length() > max_range + caution_range * int(!agg and player.casting)):
			inputV = (player.global_position - global_position).normalized()
		elif((player.global_position - global_position).length() < min_range + caution_range * int(!agg and player.casting)):
			inputV = (player.global_position - global_position).normalized() * -1
		
		velocity += inputV * 20
		
		velocity -= softBodyPush * TOPSPEED
		velocity *= Global.getTimeScale() * speedModifier
		if(slow):
			velocity = velocity * 0.5

func rotateToTarget(target, delta):
	var direction = (target - global_position)
	var angleTo = transform.x.angle_to(direction) + PI/2
	rotate(sign(angleTo) * min(delta * ROTATIONSPEED * speedModifier, abs(angleTo)))

func dist(a, b):
	var sub = a.global_position - b.global_position
	return sqrt(sub.x*sub.x + sub.y*sub.y)

func searchEffect(thing):
	var check: String
	if thing is Effects:
		check = thing.effectName.to_lower()
	elif thing is String:
		check = thing.to_lower()
	else:
		push_error("use a string or effect as a parameter you mf")
	var i = 0
	for e in effects:
		if e.effectName.to_lower() == check:
			return i
		i += 1
	return - 1

func getIntel():
	if searchEffect("Dark") != -1:
		return pow(.925,effects[searchEffect("Dark")].stack)
	return 1

func attachEffect(effect, check = true):
	if effect.enemyShows:
		var visual = effect.visual.instantiate()
		add_child(visual)
		vfx.append(visual)
	effects.append(effect)
