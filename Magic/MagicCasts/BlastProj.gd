extends CharacterBody2D
class_name Blast

var spell = null
var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null
var nvel = Vector2.ZERO
var effects = []

@onready var Fire = preload("res://Effects/Fire.tscn")
@onready var FireHit = preload("res://Effects/FireHit.tscn")
@onready var Water = preload("res://Effects/Water.tscn")
@onready var WaterHit = preload("res://Effects/WaterHit.tscn")
@onready var Normal = preload("res://Effects/Normal.tscn")

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.attributes.getSize() * mult
	spell = nspell
	if(spell.element != null and spell.element.spellName.to_lower() == "water"):
		effects.append(Soggy.new(2))
	elif(spell.element != null and spell.element.spellName.to_lower() == "fire"):
		var e = Burning.new(3)
		e.dmg = spell.attributes.getPower() * ((mult-1)/2+1)
		effects.append(e)
		
	if(spell.style != null and spell.style.spellName.to_lower() == "boar"):
		effects.append(Stun.new(2))

func _setV(nvelocity):
	nvel = nvelocity
	velocity = nvelocity.normalized() * getSpeed()
	v = velocity
	rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI

func getSpeed():
	return speed * spell.attributes.getPSpeed() * mult

func _ready():
	if(spell.element != null):
		if(spell.element.spellName.to_lower() == "water"):
			add_child(Water.instantiate())
		elif(spell.element.spellName.to_lower() == "fire") :
			add_child(Fire.instantiate())
	else:
		add_child(Normal.instantiate())

func _process(delta):
	scale = Vector2(0.5, 0.5) * spell.attributes.getSize() * mult
	if(Global.pause):
		velocity = Vector2.ZERO
	else:
		velocity = nvel.normalized() * getSpeed()
	move_and_slide()

func damageTaken(reciever):
	return spell.attributes.getPower() * ((mult-1)/2+1)

func _on_area_2d_body_entered(body) -> void:
	if is_instance_valid(body) and is_instance_valid(sender) and !(body.type == sender.type):
		body._hit(self)
		if(spell.element != null and is_instance_valid(self)):
			if(sender.type == 0):
				get_tree().current_scene.amountHit += 1
			if(effects != null):
				for e in effects:
					body.attachEffect(e)
			if(spell.element.spellName.to_lower() == "water" and get_tree() != null):
				var waterHit = WaterHit.instantiate()
				waterHit.global_position = global_position
				waterHit.scale = scale
				waterHit.emitting = true
				get_tree().current_scene.add_child(waterHit)
			elif(spell.element.spellName.to_lower() == "fire" and get_tree() != null) :
				var fireHit = FireHit.instantiate()
				fireHit.global_position = global_position
				fireHit.scale = scale
				fireHit.emitting = true
				get_tree().current_scene.add_child(fireHit)
		if(spell.style == null or spell.style.spellName.to_lower() != "monkey"):
			queue_free()

func _on_area_2d_area_entered(area):
	var body = area.get_parent()
	if(body is Blast and body.sender.type != sender.type):
		if(body.spell.initCost() * body.mult * 1/body.spell.attributes.amount > spell.initCost() * mult * 1/spell.attributes.amount and is_instance_valid(self)):
			queue_free()
		elif(is_instance_valid(body)):
			body.queue_free()
