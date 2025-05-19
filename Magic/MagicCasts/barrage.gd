extends SpellCast

signal done

var direction = Vector2.ZERO
var castingTimer = 0
var chargeTimer = 0
var timer = 0
var chargeMulti = 1.0
var speed = 1000.0
var buttonLetGo = false
var castingCost = 0
var slow = true
var startingLocation = Vector2.ZERO
var rng = RandomNumberGenerator.new()

@onready var BlastProj = preload("res://Magic/MagicCasts/BlastProj.tscn")
@onready var MagicNameCallout = preload("res://Magic/MagicCasts/MagicNameCallout.tscn")

func getMousePos():
	return get_global_mouse_position()

func setSpell(nspell):
	spell = nspell
	castingTimer = spell.getCastingTime()*5
	print("this is casting timer " + str(castingTimer))
	chargeTimer = spell.getMaxPowerTime()*10
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
	var blastProj = BlastProj.instantiate()
	blastProj.speed = speed * (50.0 + rng.randf_range(-chargeMulti,chargeMulti))/50.0
	blastProj.sender = sender
	blastProj.mult = 1.0
	blastProj.global_position = global_position
	blastProj._setSpell(spell.create())
	blastProj._setV(direction)
	blastProj.castingCost = castingCost
	blastProj.fuse = false
	get_tree().current_scene.add_child(blastProj)
	if sender.type == 0:
		get_tree().current_scene.amountShot += 1
	timer = 1 * 1/spell.getASpeed() / chargeMulti * (100.0 + rng.randf_range(-chargeMulti,chargeMulti))/100.0
	updateDirection()
		
	#direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
func updateDirection():
	if startingLocation == Vector2.ZERO:
		var ang = sender.rotation_degrees * PI/180 - PI/2 + PI/2 * (rng.randf_range(-chargeMulti,chargeMulti))/50.0
		direction = Vector2(cos(ang), sin(ang)) 
	else:
		var diff = startingLocation - get_global_mouse_position()
		var angle = atan2(diff.y, diff.x) + PI/2 * (rng.randf_range(-chargeMulti,chargeMulti))/50.0
		direction = Vector2(cos(angle + PI), sin(angle + PI))

func draw():
	draw_arc($Icon.position, 256 * 0.3 * chargeMulti, 0, 2*PI, 50, Color.WHITE)
	draw_circle(Vector2.ZERO, 256, Color.WHITE, false)

func _process(delta):
	print("This is charge multi: " + str(chargeMulti))
	delta *= Global.getTimeScale()
	if startingLocation != Vector2.ZERO:
		$Ethan.global_position = startingLocation
		$Ethan.global_scale = Vector2(0.25, 0.25)
	else:
		$Ethan.visible = false
	
	queue_redraw()
	$Pivot.rotate(PI/160*delta*120.0)
	for i in $Pivot.get_children():
		i.rotate(-PI/160*delta*120.0)
	if !is_instance_valid(sender):
		queue_free()
	if !Global.isPaused() and is_instance_valid(sender):
		if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
			done.emit()
			_nameCallout()
			queue_free()
			spell._notUsing()
		$Sprite2D.global_position = global_position + Vector2(0, -65)
		updateDirection()
		#direction = Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2))
		if (castingTimer >= 0 ):
			castingTimer -= delta
		else:
		#elif chargeTimer >= 0:
			#print(spell.contcost())
			#print(delta/spell.getMaxPowerTime())
			if chargeTimer >= 0:#sender.type == 1 or sender.stored_energy > spell.contcost() * delta/spell.getMaxPowerTime():
				#castingCost += spell.contcost() * delta/spell.getMaxPowerTime()
				chargeTimer -= delta
					#print(castingCost)
				chargeMulti *= pow(pow(1.25,delta),1/spell.getMaxPowerTime())
				scale = Vector2(0.5, 0.5) * spell.getSize()* chargeMulti
			timer -= delta
			if timer <= 0:
				_shoot()
		if startingLocation == Vector2.ZERO:
			global_position = sender.global_position + Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2)) * 100
		else:
			var diff = startingLocation - get_global_mouse_position()
			var angle = atan2(diff.y, diff.x)
			global_position = startingLocation + Vector2(cos(angle + PI), sin(angle + PI)) * 100
		if startingLocation == Vector2.ZERO:
			global_position = sender.global_position + Vector2(cos(sender.rotation_degrees * PI/180 - PI/2), sin(sender.rotation_degrees * PI/180 - PI/2)) * 100
		else:
			var diff = startingLocation - get_global_mouse_position()
			var angle = atan2(diff.y, diff.x)
			global_position = startingLocation + Vector2(cos(angle + PI), sin(angle + PI)) * 100

func letGo():
	buttonLetGo = true

#func getSpeed():
#	return speed * spell.getPSpeed() #* chargeMulti
