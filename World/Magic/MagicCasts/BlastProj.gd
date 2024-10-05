extends RigidBody2D

var spell = null
var velocity = Vector2.ZERO
var speed = 1000

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.attributes.size
	print(str(scale.x) + "PROJ")
	spell = nspell

func _setV(nvelocity):
	print(str(scale.x) + "PROJ")
	linear_velocity = nvelocity.normalized() * speed * spell.attributes.projectile_speed
	velocity = linear_velocity

func _process(delta):
	scale = Vector2(0.5, 0.5) * spell.attributes.size
