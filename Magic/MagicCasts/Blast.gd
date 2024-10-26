extends SpellCast

var direction = Vector2.ZERO
var castingTimer = 0
var chargeTimer = 0
var shot = false
var timesShot = 0
var timer = 0
var chargeMulti = 1.0
var speed = 1000
var buttonLetGo = false

@onready var BlastProj = preload("res://Magic/MagicCasts/BlastProj.tscn")

func setSpell(nspell):
	spell = nspell
	castingTimer = spell.getCastingTime()
	chargeTimer = spell.getMaxPowerTime()
	scale = Vector2(0.5, 0.5) * spell.attributes.getSize()

func _shoot():
	#print(spell.attributes.getPSpeed())
	direction = Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2))
	var blastProj = BlastProj.instantiate()
	blastProj.speed = speed
	blastProj.sender = player
	blastProj.mult = chargeMulti
	blastProj.global_position = global_position
	blastProj._setSpell(spell)
	blastProj._setV(direction)
	get_tree().current_scene.add_child(blastProj)
	timer = 0.1

func _process(delta):
	if !Global.pause and is_instance_valid(player):
		if !shot:
			if (castingTimer >= 0 ):
				castingTimer -= delta
			elif chargeTimer >= 0:
				chargeTimer -= delta
				if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
					shot = true
				chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
				scale = Vector2(0.5, 0.5) * spell.attributes.getSize()*chargeMulti
			else:
				if !Input.is_key_pressed(spell.binding):
					shot = true
			global_position = player.global_position + Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2)) * 100
		else:
			global_position = player.global_position + Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2)) * 100
			timer -= delta
			if timer < 0:
				if timesShot < spell.attributes.getAmount():
					timesShot+=1
					_shoot()
					if timesShot >= spell.attributes.getAmount():
						player.doneCasting()
						queue_free()
						spell.resetCooldown(false)

func letGo():
	buttonLetGo = true

func getSpeed():
	return speed * spell.attributes.getPSpeed() * chargeMulti
