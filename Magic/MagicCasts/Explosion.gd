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
var speed : float = 1000.0
var buttonLetGo : bool = false
var castingCost : float = 0
var slow : bool = true
var startingLocation : Vector2 = Vector2.ZERO
var rng = RandomNumberGenerator.new()

@onready var ExplosionCast := preload("res://Magic/MagicCasts/ExplosionCast.tscn")

func getMousePos() -> Vector2:
	return get_global_mouse_position()

func setSpell(nspell) -> void:
	spell = nspell
	totalChargeTime = spell.getCastingTime()
	castingTimer = totalChargeTime
	chargeTimer = spell.getMaxPowerTime()
	scale = Vector2(1, 1) * spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
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
		for i:ComponentSpellCard in spell.components:
			i.callCastingEffects(self)

func setStartingLoc(pos:Vector2) -> void:
	startingLocation = pos

func _shoot() -> void:
	var cluster = spell.getCluster()
	if cluster >= 2:
		for i in range(cluster):
			var blastProj := ExplosionCast.instantiate()
			blastProj.sender = sender
			blastProj.mult = chargeMulti
			var rangeMult = 1.5 * log(cluster + 2)
			var maxOffset = rangeMult * 130.0 * spell.getSize()
			var offset = rng.randf_range(0, maxOffset)
			var angle = rng.randf_range(0, 2*PI)
			rng.randomize()
			var offsetV = Vector2(cos(angle), sin(angle)) * offset
			blastProj.global_position = global_position + offsetV
			blastProj.castingCost = castingCost
			blastProj._setSpell(spell.create())
			get_tree().current_scene.add_child(blastProj)
	else:
		var blastProj := ExplosionCast.instantiate()
		blastProj.sender = sender
		blastProj.mult = chargeMulti
		blastProj.global_position = global_position
		blastProj.castingCost = castingCost
		blastProj._setSpell(spell.create())
		get_tree().current_scene.add_child(blastProj)
	if sender.type == 0:
		get_tree().current_scene.amountShot += 1
	timer = 0.1 * 1/spell.getASpeed()

func _process(delta : float) -> void:
	delta *= Global.getTimeScale()
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
				var diff : Vector2 = startingLocation - get_global_mouse_position()
				var angle : float = atan2(diff.y, diff.x)
				direction = Vector2(cos(angle + PI), sin(angle + PI))
			if (castingTimer >= 0 ):
				castingTimer -= delta
				scale = Vector2(1, 1) * spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
			elif chargeTimer >= 0:
				if sender.type == 1 or sender.stored_energy > spell.contcost() * delta/spell.getMaxPowerTime():
					sender.stored_energy -= spell.contcost() * delta/spell.getMaxPowerTime()
					castingCost += spell.contcost() * delta/spell.getMaxPowerTime()
					chargeTimer -= delta
					if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
						shot = true
						done.emit()
					scale = Vector2(1, 1) * spell.getSize()*chargeMulti
					chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
				else:
					shot = true
					done.emit()
			else:
				if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
					shot = true
					done.emit()
			if startingLocation == Vector2.ZERO:
				global_position = sender.global_position
			else:
				var diff : Vector2 = startingLocation - get_global_mouse_position()
				var angle : float = atan2(diff.y, diff.x)
				global_position = startingLocation
		else:
			if startingLocation == Vector2.ZERO:
				global_position = sender.global_position
			else:
				var diff : Vector2 = startingLocation - get_global_mouse_position()
				var angle : float = atan2(diff.y, diff.x)
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

func letGo() -> void:
	buttonLetGo = true

func getSpeed() -> float:
	return speed * spell.getPSpeed() * chargeMulti
