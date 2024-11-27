extends SpellCasted
class_name Blast

var v = Vector2.ZERO
var speed = 1000
var mult = 1
var sender = null
var nvel = Vector2.ZERO
var effects = []
var hit = -1

func _setSpell(nspell):
	scale = Vector2(0.5, 0.5) * nspell.getSize() * mult
	spell = nspell

func _setV(nvelocity):
	nvel = nvelocity
	velocity = nvelocity.normalized() * getSpeed()
	v = velocity
	rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI

func getSpeed():
	return speed * spell.getPSpeed() * mult

func _ready():
	if(spell.element != null):
		spell.element.callStartEffects(self)

func _process(delta):
	if(spell.element != null):
		spell.element.callOngoingEffects(self)
	scale = Vector2(0.5, 0.5) * spell.getSize() * mult
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
			if(spell.element != null):
				spell.element.callHitEffects(self, body)
			if(spell.style != null):
				spell.style.callHitEffects(self, body)
		queue_free()

func _on_area_2d_area_entered(area):
	var body = area.get_parent()
	if(body is Blast and is_instance_valid(body.sender) and is_instance_valid(sender) and body.sender.type != sender.type):
		if(body.spell.initCost() * body.mult * 1/body.spell.attributes.amount > spell.initCost() * mult * 1/spell.attributes.amount and is_instance_valid(self)):
			queue_free()
		elif(is_instance_valid(body)):
			body.queue_free()
