extends SpellCast

signal done

static var shieldsMade : Array[Shield] = []
var castingTimer : float = 0
var totalChargeTime : float = 0
var chargeTimer : float = 0
var shot : bool = false
var timesShot : int = 0
var timer : float = 0
var chargeMulti : float = 1.0
var buttonLetGo : bool = false
var castingCost = 0
var slow : bool = true
var id = -1;
var segSize : float = 0.0
var angleOffset : float = 0.0
var speed : float = 100.0

@onready var ShieldCast := preload("res://Magic/MagicCasts/ShieldCast.tscn")

func setSpell(nspell : Spell) -> void:
	for i in range(shieldsMade.size()):
		if (shieldsMade[i].spell.name == nspell.name):
			shieldsMade[i].queue_free()
			shieldsMade.remove_at(i)
			sender.doneCasting()
			print("stop shield")
			done.emit()
			slow = false
			queue_free()
			return
	
	spell = nspell
	totalChargeTime = spell.getCastingTime()
	castingTimer = totalChargeTime
	chargeTimer = spell.getMaxPowerTime()
	segSize = spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
	speed *= spell.getPSpeed()
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
	var id = Shield.idTotal
	Shield.idTotal += 1

func _process(delta:float) -> void:
	delta *= Global.getTimeScale()
	angleOffset += delta * speed
	
	global_position = sender.global_position
	
	queue_redraw()
	$Pivot.rotate(PI/160*delta*120.0)
	for i : Node2D in $Pivot.get_children():
		i.rotate(-PI/160*delta*120.0)
	if !is_instance_valid(sender):
		queue_free()
	if !Global.isPaused() and is_instance_valid(sender):
		$Sprite2D.global_position = global_position + Vector2(0, -65)
		if !shot:
			if (castingTimer >= 0 ):
				castingTimer -= delta
				segSize = spell.getSize() * _castingAnimationCalc(castingTimer,totalChargeTime)
			elif chargeTimer >= 0:
				if sender.type == 1 or sender.stored_energy > spell.contcost() * delta/spell.getMaxPowerTime():
					sender.stored_energy -= spell.contcost() * delta/spell.getMaxPowerTime()
					castingCost += spell.contcost() * delta/spell.getMaxPowerTime()
					chargeTimer -= delta
					if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
						shot = true
						done.emit()
					segSize = 0.5 * spell.getSize()*chargeMulti
					chargeMulti *= pow(pow(2,delta),1/spell.getMaxPowerTime())
				else:
					shot = true
					done.emit()
			else:
				if buttonLetGo or (spell.binding != null and !Input.is_key_pressed(spell.binding)):
					shot = true
					done.emit()
		else:
			_cast()
			sender.doneCasting()
			queue_free()

func _cast():
	print("casting the shield")
	var shieldCast := ShieldCast.instantiate()
	shieldCast.spell = spell
	shieldCast.segSize = segSize
	shieldCast.angleOffset = angleOffset
	shieldCast.sender = sender
	get_tree().current_scene.add_child(shieldCast)
	shieldsMade.append(shieldCast)
	
	if sender.type == 0:
		for i in Global.spellList:
			if (i.name == spell.name):
				i.cooldown = 0
				i.free = true
	
	queue_free()
	#create shield

func letGo():
	buttonLetGo = true

func _draw():
	if (spell != null):
		var x = segSize
		var angleLen = (200 * pow(x, (1/3)))/((pow(x, (1/3)) + 1) * spell.getAmount())
		
		for i in range(spell.getAmount()):
			draw_arc(Vector2.ZERO, 150, (i * 360/spell.getAmount() - angleLen/2 + angleOffset)*(PI/180), (i * 360/spell.getAmount() + angleLen/2 + angleOffset)*(PI/180), 20, Color(1, 1, 1, 0.5), 5)
	
