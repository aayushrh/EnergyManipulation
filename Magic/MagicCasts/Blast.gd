extends SpellCast

signal done

var direction = Vector2.ZERO
var castingTimer = 0
var chargeTimer = 0
var shot = false
var timesShot = 0
var timer = 0
var chargeMulti = 1.0
var speed = 1000.0
var buttonLetGo = false
var castingCost = 0

@onready var BlastProj = preload("res://Magic/MagicCasts/BlastProj.tscn")
@onready var MagicNameCallout = preload("res://Magic/MagicCasts/MagicNameCallout.tscn")

func setSpell(nspell):
	spell = nspell
	for i in spell.components:
		i.callCastingEffects(self)
	castingTimer = spell.getCastingTime()
	chargeTimer = spell.getMaxPowerTime()
	scale = Vector2(0.5, 0.5) * spell.getSize()
	#if(spell.style.size() > 0):
		#$Sprite2D.texture = spell.style[0].icon
		#$Sprite2D.scale = Vector2(0.3, 0.3)
	if(spell.type):
		$Icon.texture = spell.type.icon
		$Icon.self_modulate = Color(spell.type.color, 0.5)
		$Icon.scale = Vector2(0.3, 0.3)
	for i in range(spell.components.size()):
		var icon = Sprite2D.new()
		icon.texture = spell.components[i].icon
		icon.self_modulate = Color(spell.components[i].color, 0.5)
		icon.scale = Vector2(0.15, 0.15)
		icon.position = Vector2(sin(i/(spell.components.size()+0.0) * 2*PI) * 500*0.3, cos(i/(spell.components.size()+0.0) * 2*PI) * 500*0.3)
		print("this is i: " + str(i))
		print(icon.position)
		$Pivot.add_child(icon)

func _nameCallout():
	pass
	#var magicNameCallout = MagicNameCallout.instantiate()
	#magicNameCallout.position = Vector2(0, 60)
	#magicNameCallout._show(spell)
	#player.add_child(magicNameCallout)

func _shoot():
	#print(spell.attributes.getPSpeed())
	var blastProj = BlastProj.instantiate()
	blastProj.speed = speed
	blastProj.sender = player
	blastProj.mult = chargeMulti
	blastProj.global_position = global_position
	blastProj._setSpell(spell)
	blastProj._setV(direction)
	get_tree().current_scene.add_child(blastProj)
	if player.type == 0:
		get_tree().current_scene.amountShot += 1
	timer = 0.1 * 1/spell.getASpeed()
	direction = Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2))

func draw():
	draw_arc($Icon.position, 256 * 0.3 * chargeMulti, 0, 2*PI, 50, Color.WHITE)
	draw_circle(Vector2.ZERO, 256, Color.WHITE, false)

func _process(delta):
	queue_redraw()
	$Pivot.rotate(PI/160)
	for i in $Pivot.get_children():
		i.rotate(-PI/160)
	if !is_instance_valid(player):
		queue_free()
	if !Global.isPaused() and is_instance_valid(player):
		$Sprite2D.global_position = player.global_position + Vector2(0, -65)
		if !shot:
			direction = Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2))
			if (castingTimer >= 0 ):
				castingTimer -= delta
			elif chargeTimer >= 0:
				#print(spell.contcost())
				#print(delta/spell.getMaxPowerTime())
				if player.type == 1 or player.stored_energy > spell.contcost() * delta/spell.getMaxPowerTime():
					player.stored_energy -= spell.contcost() * delta/spell.getMaxPowerTime()
					castingCost += spell.contcost() * delta/spell.getMaxPowerTime()
					chargeTimer -= delta
					if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
						shot = true
						done.emit()
						_nameCallout()
						#print(castingCost)
					chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
					scale = Vector2(0.5, 0.5) * spell.getSize()*chargeMulti
				else:
					shot = true
					done.emit()
					_nameCallout()
			else:
				if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
					shot = true
					done.emit()
					_nameCallout()
			global_position = player.global_position + Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2)) * 100
		else:
			global_position = player.global_position + Vector2(cos(player.rotation_degrees * PI/180 - PI/2), sin(player.rotation_degrees * PI/180 - PI/2)) * 100
			timer -= delta
			if timer <= 0:
				if timesShot < spell.getAmount():
					timesShot+=1
					_shoot()
					if timesShot >= spell.getAmount():
						player.doneCasting()
						#if(spell.style != null and spell.style.spellName.to_lower() == "horse"):
							#player.stored_energy += 0.36 * (spell.initCost() + castingCost)
						queue_free()
						spell._notUsing()

func letGo():
	buttonLetGo = true

func getSpeed():
	return speed * spell.getPSpeed() * chargeMulti
