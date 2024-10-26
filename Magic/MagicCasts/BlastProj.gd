extends CharacterBody2D
class_name Blast

var spell = null
var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null
var nvel = Vector2.ZERO

@onready var Fire = preload("res://Effects/Fire.tscn")
@onready var Water = preload("res://Effects/Water.tscn")
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
		if(spell.element != null):
			if(spell.element.spellName.to_lower() == "water"):
				body.attachEffect(Soggy.new(100))
				print("e")
			elif(spell.element.spellName.to_lower() == "fire") :
				body.attachEffect(Burning.new(50))
		queue_free()
