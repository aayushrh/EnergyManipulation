extends SpellCast

var castingTimer = 0
var chargeTimer = 0
var shot = false
var timesShot = 0
var timer = 0
var chargeMulti = 1.0

@onready var ExplosionCast = preload("res://Magic/MagicCasts/ExplosionCast.tscn")

func setSpell(nspell):
	spell = nspell
	castingTimer = spell.getCastingTime()
	chargeTimer = spell.getMaxPowerTime()
	scale = Vector2(1, 1) 

func _shoot():
	#print(spell.attributes.getPSpeed())
	#direction = Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2))
	var explosionCast = ExplosionCast.instantiate()
	explosionCast.mult = chargeMulti
	explosionCast.global_position = global_position
	explosionCast._setSpell(spell)
	get_tree().current_scene.add_child(explosionCast)
	timer = 0.1

func _process(delta):
	if !shot:
		if (castingTimer >= 0 ):
			castingTimer -= delta
		elif chargeTimer >= 0:
			chargeTimer -= delta
			if !Input.is_key_pressed(spell.binding):
				shot = true
			chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
			scale = Vector2(1, 1) * chargeMulti
		else:
			if !Input.is_key_pressed(spell.binding):
				shot = true
		global_position = player.global_position 
	else:
		global_position = player.global_position 
		timer -= delta
		if timer < 0:
			timesShot+=1
			_shoot()
			player.doneCasting(false)
			queue_free()
