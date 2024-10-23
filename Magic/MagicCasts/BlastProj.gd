extends CharacterBody2D
class_name Blast

var spell = null
var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null
var nvel = Vector2.ZERO

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.attributes.getSize() * mult
	spell = nspell

func _setV(nvelocity):
	nvel = nvelocity
	velocity = nvelocity.normalized() * getSpeed()
	v = velocity

func getSpeed():
	return speed * spell.attributes.getPSpeed() * mult

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
				body.effects.append(Soggy.new(100))
				print("e")
			elif(spell.element.spellName.to_lower() == "fire") :
				body.effects.append(Burning.new(50))
		queue_free()
