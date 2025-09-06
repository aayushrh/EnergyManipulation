extends SpellCast

signal done

var direction : Vector2 = Vector2.ZERO
var castingTimer : float = 0
var totalChargeTime : float = 0
var chargeTimer : float = 0
var shot : bool = false
var timesShot : int = 0
var timer : float = 0
var chargeMulti : float = 1.0
var speed = 1000.0
var buttonLetGo : bool = false
var castingCost = 0
var slow : bool = true
var startingLocation : Vector2 = Vector2.ZERO

@onready var BlastProj := preload("res://Magic/MagicCasts/BlastProj.tscn")

func getMousePos() -> Vector2:
	return get_global_mouse_position()

func setSpell(nspell : Spell) -> void:
	spell = nspell
	totalChargeTime = spell.getCastingTime()
	castingTimer = totalChargeTime
	chargeTimer = spell.getMaxPowerTime()
	#scale = Vector2(0.5, 0.5) * spell.getSize()
	scale = Vector2(0.5, 0.5) * spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
	#if(spell.style.size() > 0):
		#$Sprite2D.texture = spell.style[0].icon
		#$Sprite2D.scale = Vector2(0.3, 0.3)
	if(spell.type):
		$Icon.texture = spell.type.icon
		$Icon.self_modulate = Color(spell.type.color, 0.5)
		$Icon.scale = Vector2(0.3, 0.3)
	for i : int in range(spell.components.size()):
		var icon := Sprite2D.new()
		icon.texture = spell.components[i].icon
		icon.self_modulate = Color(spell.components[i].color, 0.5)
		icon.scale = Vector2(0.15, 0.15)
		icon.position = Vector2(sin(i/(spell.components.size()+0.0) * 2*PI) * 500*0.3, cos(i/(spell.components.size()+0.0) * 2*PI) * 500*0.3)
		$Pivot.add_child(icon)

func _ready() -> void:
	if spell != null:
		for i : ComponentSpellCard in spell.components:
			i.callCastingEffects(self)

func setStartingLoc(pos : Vector2) -> void:
	startingLocation = pos

func _shoot() -> void:
	var cluster = spell.getCluster()
	
	for i in range(cluster):
		var blastProj := BlastProj.instantiate()
		blastProj.speed = speed
		blastProj.sender = sender
		blastProj.mult = chargeMulti
		blastProj.global_position = global_position
		blastProj._setSpell(spell.create())
		if cluster >= 2:
			var range = 0.5*log(cluster + 2)
			var aoffset = (((float)(i - cluster / 2))/(float)(cluster)) * range
			var ndir = direction.rotated(aoffset)
			blastProj._setV(ndir)
		else:
			blastProj._setV(direction)
		blastProj.castingCost = castingCost
		get_tree().current_scene.add_child(blastProj)
		if sender.type == 0:
			get_tree().current_scene.amountShot += 1
	
	timer = 0.1 * 1/spell.getASpeed()
	if startingLocation == Vector2.ZERO:
		direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
	else:
		var diff := startingLocation - get_global_mouse_position()
		var angle := atan2(diff.y, diff.x)
		direction = Vector2(cos(angle + PI), sin(angle + PI))

func _process(delta:float) -> void:
	delta *= Global.getTimeScale()
	if startingLocation != Vector2.ZERO:
		$Ethan.global_position = startingLocation
		$Ethan.global_scale = Vector2(0.25, 0.25)
	else:
		$Ethan.visible = false
	
	queue_redraw()
	$Pivot.rotate(PI/160*delta*120.0)
	for i : Node2D in $Pivot.get_children():
		i.rotate(-PI/160*delta*120.0)
	if !is_instance_valid(sender):
		queue_free()
	if !Global.isPaused() and is_instance_valid(sender):
		$Sprite2D.global_position = global_position + Vector2(0, -65)
		if !shot:
			if startingLocation == Vector2.ZERO:
				direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
			else:
				var diff := startingLocation - get_global_mouse_position()
				var angle := atan2(diff.y, diff.x)
				direction = Vector2(cos(angle + PI), sin(angle + PI))
			#direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
			if (castingTimer >= 0 ):
				castingTimer -= delta
				scale = Vector2(0.5, 0.5) * spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
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
						#print(castingCost)
					scale = Vector2(0.5, 0.5) * spell.getSize()*chargeMulti
					chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
				else:
					shot = true
					done.emit()
			else:
				if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
					shot = true
					done.emit()
			if startingLocation == Vector2.ZERO:
				global_position = sender.global_position + Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2)) * 100
			else:
				var diff := startingLocation - get_global_mouse_position()
				var angle := atan2(diff.y, diff.x)
				global_position = startingLocation + Vector2(cos(angle + PI), sin(angle + PI)) * 100
		else:
			if startingLocation == Vector2.ZERO:
				global_position = sender.global_position + Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2)) * 100
			else:
				var diff := startingLocation - get_global_mouse_position()
				var angle := atan2(diff.y, diff.x)
				global_position = startingLocation + Vector2(cos(angle + PI), sin(angle + PI)) * 100
			timer -= delta
			if timer <= 0:
				if timesShot < spell.getAmount():
					timesShot+=1
					_shoot()
					if timesShot >= spell.getAmount():
						sender.doneCasting()
						queue_free()
						spell._notUsing()

func letGo():
	buttonLetGo = true

func getSpeed():
	return speed * spell.getPSpeed() * chargeMulti
