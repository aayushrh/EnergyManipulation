extends SpellCasted
class_name Blast

var v : Vector2 = Vector2.ZERO
var speed : float = 1000
var mult : float = 1
var sender : CharacterBody2D = null
var hit : int = -1
var art : Node2D
var setSize : bool = false
var setPower : bool = false
var power : float = 0
var castingCost : float = 0
var combined : bool = false
var lifetime : float = 100.0
var fuse : bool = true

var BlastProj := preload("res://Magic/MagicCasts/BlastProj.tscn")

func _setSpell(nspell : Spell) -> void:
	scale = Vector2(0.5, 0.5) * nspell.getSize() * mult
	spell = nspell

func _setV(nvelocity : Vector2) -> void:
	velocity = nvelocity.normalized() * getSpeed()
	v = velocity
	rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI

func _setPower(p : float) -> void:
	power = p
	setPower = true

func _setSize(size : Vector2) -> void:
	scale = size
	setSize = true

func getSpeed() -> float:
	return speed * spell.getPSpeed() #* mult

func _ready() -> void:
	art = $Art
	
	if !spell.hasElement():
		spell.components.append(Global.defaultElement)
	for i : ComponentSpellCard in spell.components:
		i.callStartEffects(self)

func _physics_process(_delta : float) -> void:
	_delta *= Global.getTimeScale()
	lifetime -= _delta
	if(lifetime<0):
		queue_free()
	for i : ComponentSpellCard in spell.components:
		i.callOngoingEffects(self)
	if !setSize:
		scale = Vector2(0.5, 0.5) * spell.getSize() * mult
	$Art.processed = true
	velocity = v * Global.getTimeScale()
	move_and_slide()

func damageTaken() -> float:
	if !setPower:
		return spell.getPower() * ((mult-1)/2.0+1) * sender.getIntel()
	return power

func clone() -> Blast:
	var blast := Blast.new()
	blast.global_position = global_position
	blast.spell = spell
	blast.sender = sender
	return blast

func _on_area_2d_body_entered(body : Node2D) -> void:
	if is_instance_valid(body) and is_instance_valid(sender) and !(body.type == sender.type):
		body._hit(self)
		if(spell.components != null and is_instance_valid(self)):
			if(sender.type == 0 and body.type == 1):
				if(hit == -1):
					get_tree().current_scene.amountHit += 1
				else:
					get_tree().current_scene.multiHits += 1
				hit += 1
			for i:ComponentSpellCard in spell.components:
				i.callHitEffects(self, body)
		queue_free()

func _on_area_2d_area_entered(area : Area2D) -> void:
	var body := area.get_parent()
	if(body is Blast and is_instance_valid(body.sender) and is_instance_valid(sender) and body.sender.type != sender.type):
		if(abs(body.spell.initCost() * body.mult * body.spell.getClashingAdvantage()  - spell.initCost() * mult * spell.getClashingAdvantage()) > (spell.initCost() * mult * spell.getClashingAdvantage() + body.spell.initCost() * body.mult * body.spell.getClashingAdvantage())/16):
			if(is_instance_valid(body)):
				
				for i : ComponentSpellCard in body.spell.components:
					i.callVisualHitEffects(body)
				body.queue_free()
			if(is_instance_valid(self)):
				for i : ComponentSpellCard in spell.components:
					i.callVisualHitEffects(self)
				queue_free()
		elif(body.spell.initCost() * body.mult * body.spell.getClashingAdvantage()  > spell.initCost() * mult * spell.getClashingAdvantage()  and is_instance_valid(self)):
			for i : ComponentSpellCard in spell.components:
				i.callVisualHitEffects(self)
			queue_free()
		elif(is_instance_valid(body)):
			for i : ComponentSpellCard in body.spell.components:
				i.callVisualHitEffects(body)
			body.queue_free()
	elif(body is Blast and is_instance_valid(body.sender) and is_instance_valid(sender) and body.sender.type == sender.type) and body.spell.type == spell.type and body.spell.spellName != spell.spellName:
		if(body.fuse && fuse):
			if(body.global_position.x + body.global_position.y < global_position.x + global_position.y):
				var blast := BlastProj.instantiate()
				var nspell := Spell.new("newThing")
				blast.combined = true
				nspell.components.append_array(spell.components)
				nspell.components.append_array(body.spell.components)
				var j : int = 0
				while j < nspell.components.size():
					if nspell.components[j] == Global.defaultElement:
						nspell.components.remove_at(j)
						j -= 1
					j += 1
				nspell.type = spell.type
				blast.mult = body.mult + mult
				blast._setSpell(nspell)
				blast._setPower(spell.getPower() * ((mult-1)/2+1) * sender.getIntel() + body.spell.getPower() * ((body.mult-1)/2+1) * body.sender.getIntel())
				blast._setSize(scale + body.scale)
				blast._setV((body.velocity.normalized() + velocity.normalized()) * 0.5 * (velocity.length() + body.velocity.length())/2)
				blast.global_position = (global_position + body.global_position)/2
				blast.sender = sender
				for i : ComponentSpellCard in spell.components:
					i.callVisualHitEffects(self)
				for i : ComponentSpellCard in body.spell.components:
					i.callVisualHitEffects(body)
				queue_free()
				body.queue_free()
				get_tree().current_scene.add_child(blast)
