extends CharacterBody2D
class_name Blast

var spell = null
var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null
var nvel = Vector2.ZERO

@onready var Fire = preload("res://Effects/Fire.tscn")
@onready var FireHit = preload("res://Effects/FireHit.tscn")
@onready var Water = preload("res://Effects/Water.tscn")
@onready var WaterHit = preload("res://Effects/WaterHit.tscn")
@onready var Normal = preload("res://Effects/Normal.tscn")

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.attributes.getSize() * mult
	spell = nspell

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
	return spell.attributes.getPower()

func _on_area_2d_body_entered(body) -> void:
	if !(body.type == sender.type):
		body._hit(self)
		if(spell.element != null and is_instance_valid(self)):
			if(spell.element.spellName.to_lower() == "water"):
				body.attachEffect(Soggy.new(5))
				var waterHit = WaterHit.instantiate()
				waterHit.global_position = global_position
				waterHit.scale = scale
				waterHit.emitting = true
				get_tree().current_scene.add_child(waterHit)
			elif(spell.element.spellName.to_lower() == "fire") :
				body.attachEffect(Burning.new(3))
				var fireHit = FireHit.instantiate()
				fireHit.global_position = global_position
				fireHit.scale = scale
				fireHit.emitting = true
				get_tree().current_scene.add_child(fireHit)
		queue_free()

func _on_area_2d_area_entered(area):
	var body = area.get_parent()
	if(body is Blast and body.sender.type != sender.type):
		if(body.spell.initCost() * body.mult * 1/body.spell.attributes.amount > spell.initCost() * mult * 1/spell.attributes.amount and is_instance_valid(self)):
			queue_free()
		elif(is_instance_valid(body)):
			body.queue_free()
