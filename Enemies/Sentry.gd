extends CharacterBody2D
class_name Sentry

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
var nomoveinput = false
var wisdom = 1.0
var fuck = false # fuck nature
var dodgeDir = 0
var moveDir = 0.0
var blast = null
var casting = false
var healing = 1.0
var MAXHEALTH = 0
var MAXMANA = 100.0 : set = _max_mana_change
var agg = false#(randi_range(0,1)==0)
var pause = false
var stored_energy = MAXMANA : set = _energy_change
var mana = stored_energy
var blinded = false
var reactionDelay = 0.0
var intel = 1
var hp = 0.0
var stage = 0
var delt = 0
var prediction = false
var healthbar = null
var chargeTime = 0

@export var HPBARMULT = 80.0
@export var BARSPEED = 20.0
@export var health = 0.0 : set = _health_change
@export var checkAngle = 45 # angle checked for things that will be going towards them
@export var blockOrFlight = 2 # how many will have to be going for it to block
@export var tact = 100 - int(agg)*75 # chance to do smarter things
@export var DASHSPEED = 2500
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

@export var testShapeCard : TypeSpellCard
@export var componentCards : Array[ComponentSpellCard]

@onready var BlastTscn = preload("res://Magic/MagicCasts/Blast.tscn")
@onready var Explosion = preload("res://Magic/MagicCasts/Explosion.tscn")
@onready var HealthBar = preload("res://enemy_health.tscn")
@onready var DamageNum = preload("res://Effects/DamageNum.tscn")

func _ready():
	rng.randomize()
	var spell = Spell.new("firstSpell")
	spell.type = testShapeCard
	spell.components = componentCards
	health = 5.0
	spells = [spell]

func _finishCharge():
	slow = false
	ROTATIONSPEED *= 2

func _physics_process(delta):
	delta *= Global.getTimeScale()
	delt = delta
	if(!Global.isPaused() and !pause):
		if(health != hp):
			updateHP(delta)
		queue_redraw()
		time+=delta
		_shoot(delta)

func _max_mana_change(newMax: float):
	healthbar.update_maxMana(newMax)
	MAXMANA = newMax

func _shoot(delta):
	if(player!=null):
		var track = -1
		for e:Spell in spells:
			track += 1
			if(!e.using):
				e.cooldown -= delta
			if(dodgeDir == 0 and e.cooldown < 0 and !casting):
				blast = e._cast(self)
				blast.letGo()
				castedIndex = track
				slow = true
				ROTATIONSPEED /= 2
				e.resetCooldown(true, 1)
				casting = true
	
func _health_change(newHP: float):
	pass

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

func _effectsHandle(delta):
	for e in effects:
		e._tick(self, delta)

func _hit(hitbox):
	pass
	"""dmgTaken = hitbox.damageTaken()
	health -= dmgTaken
	time = 0"""

func doneCasting():
	slow = false
	ROTATIONSPEED *= 2
	casting = false

func energyGain(delta):
	$Charging.emitting = stored_energy < MAXMANA

	stored_energy += delta * wisdom * 0.05 * pow(chargeTime,2)
	chargeTime += delta
	if(!$Charging.emitting):
		chargeTime = 0

func attachEffect(effect):
	if effect.enemyShows:
		var visual = effect.visual.instantiate()
		add_child(visual)
		vfx.append(visual)
	effects.append(effect)

func getIntel():
	return 1
