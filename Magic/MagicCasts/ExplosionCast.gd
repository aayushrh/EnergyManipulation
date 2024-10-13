extends CharacterBody2D

var spell = null
var speed = 1000
var lifetime = 10
var mult = 1

func _setSpell(nspell):
	scale = Vector2(1, 1) * nspell.attributes.getSize() * mult
	spell = nspell

func _process(delta):
	scale = Vector2(1, 1) * spell.attributes.getSize() * mult
	lifetime -= 1
	if(lifetime < 0):
		queue_free()
