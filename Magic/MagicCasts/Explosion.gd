extends SpellCast

signal done

var direction = Vector2.ZERO
var castingTimer = 0
var totalChargeTime = 0
var chargeTimer = 0
var shot = false
var timesShot = 0
var timer = 0
var chargeMulti = 1.0
var speed = 1000.0
var buttonLetGo = false
var castingCost = 0
var slow = true
var startingLocation = Vector2.ZERO

@onready var ExplosionCast = preload("res://Magic/MagicCasts/ExplosionCast.tscn")

func getMousePos():
	return get_global_mouse_position()

func setSpell(nspell):
	spell = nspell
	totalChargeTime = spell.getCastingTime()
	castingTimer = totalChargeTime
	chargeTimer = spell.getMaxPowerTime()
	#scale = Vector2(0.5, 0.5) * spell.getSize()
	scale = Vector2(1, 1) * spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
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
		print(icon.position)
		$Pivot.add_child(icon)

func _ready():
	if spell != null:
		for i in spell.components:
			i.callCastingEffects(self)

func setStartingLoc(pos):
	startingLocation = pos

func _nameCallout():
	pass
	#var magicNameCallout = MagicNameCallout.instantiate()
	#magicNameCallout.position = Vector2(0, 60)
	#magicNameCallout._show(spell)
	#sender.add_child(magicNameCallout)

func _shoot():
	#print(spell.attributes.getPSpeed())
	var blastProj = ExplosionCast.instantiate()
	blastProj.sender = sender
	blastProj.mult = chargeMulti
	blastProj.global_position = global_position
	blastProj.castingCost = castingCost
	blastProj._setSpell(spell.create())
	get_tree().current_scene.add_child(blastProj)
	if sender.type == 0:
		get_tree().current_scene.amountShot += 1
	timer = 0.1 * 1/spell.getASpeed()
		
	#direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))

func draw():
	draw_arc($Icon.position, 256 * 0.3 * chargeMulti, 0, 2*PI, 50, Color.WHITE)
	draw_circle(Vector2.ZERO, 256, Color.WHITE, false)

func _process(delta):
	delta *= Global.getTimeScale()
	
	queue_redraw()
	$Pivot.rotate(PI/160*delta*120.0)
	for i in $Pivot.get_children():
		i.rotate(-PI/160*delta*120.0)
	if !is_instance_valid(sender):
		queue_free()
	if !Global.isPaused() and is_instance_valid(sender):
		$Sprite2D.global_position = global_position + Vector2(0, -65)
		if !shot:
			if startingLocation == Vector2.ZERO:
				direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
			else:
				var diff = startingLocation - get_global_mouse_position()
				var angle = atan2(diff.y, diff.x)
				direction = Vector2(cos(angle + PI), sin(angle + PI))
			#direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
			if (castingTimer >= 0 ):
				castingTimer -= delta
				scale = Vector2(1, 1) * spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
			elif chargeTimer >= 0:
				#print(spell.contcost())
				#print(delta/spell.getMaxPowerTime())
				if sender.type == 1 or sender.stored_energy > spell.contcost() * delta/spell.getMaxPowerTime():
					sender.stored_energy -= spell.contcost() * delta/spell.getMaxPowerTime()
					castingCost += spell.contcost() * delta/spell.getMaxPowerTime()
					chargeTimer -= delta
					if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
						shot = true
						done.emit()
						_nameCallout()
						#print(castingCost)
					scale = Vector2(1, 1) * spell.getSize()*chargeMulti
					chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
				else:
					shot = true
					done.emit()
					_nameCallout()
			else:
				if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
					shot = true
					done.emit()
					_nameCallout()
			if startingLocation == Vector2.ZERO:
				global_position = sender.global_position
			else:
				var diff = startingLocation - get_global_mouse_position()
				var angle = atan2(diff.y, diff.x)
				global_position = startingLocation
		else:
			if startingLocation == Vector2.ZERO:
				global_position = sender.global_position
			else:
				var diff = startingLocation - get_global_mouse_position()
				var angle = atan2(diff.y, diff.x)
				global_position = startingLocation
			timer -= delta
			if timer <= 0:
				if timesShot < spell.getAmount():
					timesShot+=1
					_shoot()
					if timesShot >= spell.getAmount():
						sender.doneCasting()
						#if(spell.style != null and spell.style.spellName.to_lower() == "horse"):
							#sender.stored_energy += 0.36 * (spell.initCost() + castingCost)
						queue_free()
						spell._notUsing()

func letGo():
	buttonLetGo = true

func getSpeed():
	return speed * spell.getPSpeed() * chargeMulti
