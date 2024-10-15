extends CharacterBody2D
class_name Blast

var spell = null
var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.attributes.getSize() * mult
	spell = nspell

func _setV(nvelocity):
	velocity = nvelocity.normalized() * speed * spell.attributes.getPSpeed() * mult
	v = velocity

func _process(delta):
	scale = Vector2(0.5, 0.5) * spell.attributes.getSize() * mult
	move_and_slide()

func damageTaken(reciever):
	return spell.attributes.getPower()


func _on_area_2d_body_entered(body) -> void:
	if !(body.type == sender.type):
		body._hit(self)
		queue_free()
