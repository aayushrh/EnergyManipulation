extends SpellCast

var direction = Vector2.ZERO
var castingTimer = 0
var chargeTimer = 0
var shot = false
var timesShot = 0
var timer = 0

@onready var BlastProj = preload("res://World/Magic/MagicCasts/BlastProj.tscn")

func setSpell(nspell):
	spell = nspell
	castingTimer = spell.getCastingTime()
	chargeTimer = spell.getMaxPowerTime()
	scale = Vector2(0.5, 0.5) * spell.attributes.size
	print(str(scale.x) + "SPAWN")

func _shoot():
	direction = Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2))
	var blastProj = BlastProj.instantiate()
	blastProj.global_position = global_position
	blastProj._setSpell(spell)
	blastProj._setV(direction)
	get_tree().current_scene.add_child(blastProj)
	timer = 0.1

func _process(delta):
	if !shot:
		if (castingTimer >= 0 ):
			castingTimer -= delta
		elif chargeTimer >= 0:
			chargeTimer -= delta
			if !Input.is_key_pressed(spell.binding):
				shot = true
			spell.attributes.power *= 1.01
		else:
			if !Input.is_key_pressed(spell.binding):
				shot = true
		global_position = player.global_position + Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2)) * 100
	else:
		global_position = player.global_position + Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2)) * 100
		timer -= delta
		if timer < 0:
			if timesShot < spell.attributes.amount:
				timesShot+=1
				_shoot()
			else:
				player.doneCasting()
				queue_free()
