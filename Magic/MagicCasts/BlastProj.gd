extends SpellCasted
class_name Blast

var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null
var nvel = Vector2.ZERO
var effects = []
var hit = -1
var art : Node2D

var BlastProj = preload("res://Magic/MagicCasts/BlastProj.tscn")
var CombinedBlast = preload("res://Magic/MagicCasts/CombinedBlasts.tscn")

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.getSize() * mult
	spell = nspell

func _setV(nvelocity):
	nvel = nvelocity
	velocity = nvelocity.normalized() * getSpeed()
	v = velocity
	rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI

func _setSize(size):
	scale = size

func getSpeed():
	return speed * spell.getPSpeed() * mult

func _ready():
	art = $Art
	for i in spell.element:
		i.callStartEffects(self)
	#$CollisionShape2D.shape.radius = 75 * mult * 0.8 * spell.getSize()
	#$Area2D/CollisionShape2D.shape.radius = 75 * mult * 0.8 * spell.getSize()

func _process(delta):
	for i in spell.element:
		i.callOngoingEffects(self)
	scale = Vector2(0.5, 0.5) * spell.getSize() * mult
	$Art.processed = true
	print("Blast scale x: " + str(scale.x))
	if(Global.isPaused()):
		velocity = Vector2.ZERO
	else:
		velocity = nvel.normalized() * getSpeed()
	move_and_slide()

func damageTaken(reciever):
	return spell.getPower() * ((mult-1)/2+1) * sender.intel

func clone():
	var blast = Blast.new()
	blast.global_position = global_position
	blast.spell = spell
	blast.sender = sender
	return blast

func _on_area_2d_body_entered(body) -> void:
	if is_instance_valid(body) and is_instance_valid(sender) and !(body.type == sender.type):
		body._hit(self)
		if(spell.element != null and is_instance_valid(self)):
			if(sender.type == 0 and body.type == 1):
				if(hit == -1):
					get_tree().current_scene.amountHit += 1
				else:
					get_tree().current_scene.multiHits += 1
				hit += 1
			for i in spell.element:
				i.callHitEffects(self, body)
			for i in spell.style:
				i.callHitEffects(self, body)
		queue_free()

func _on_area_2d_area_entered(area):
	var body = area.get_parent()
	if(body is Blast and is_instance_valid(body.sender) and is_instance_valid(sender) and body.sender.type != sender.type):
		if(body.spell.initCost() * body.mult * 1/body.spell.attributes.amount > spell.initCost() * mult * 1/spell.attributes.amount and is_instance_valid(self)):
			queue_free()
		elif(is_instance_valid(body)):
			body.queue_free()
	elif(body is Blast and is_instance_valid(body.sender) and is_instance_valid(sender) and body.sender.type == sender.type) and body.spell.type == spell.type:
		if(body.global_position.x + body.global_position.y < global_position.x + global_position.y):
			var blast = BlastProj.instantiate()
			var nspell = Spell.new("newThing")
			nspell.element.append_array(spell.element)
			nspell.element.append_array(body.spell.element)
			nspell.style.append_array(spell.style)
			nspell.style.append_array(body.spell.style)
			nspell.type = spell.type
			blast._setSize(scale + body.scale)
			#blast.mult = body.mult + mult
			blast._setSpell(nspell)
			blast._setV((body.velocity + velocity)/2)
			blast.global_position = (global_position + body.global_position)/2
			blast.sender = sender
			for i in spell.element:
				i.callVisualHitEffects(self)
			for i in body.spell.element:
				i.callVisualHitEffects(body)
			queue_free()
			body.queue_free()
			get_tree().current_scene.add_child(blast)
