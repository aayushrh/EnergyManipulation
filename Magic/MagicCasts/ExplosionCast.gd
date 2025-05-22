extends SpellCasted
class_name Explosion

var delay_base : float = 0.1
var radius : float = 100.0
var sender : CharacterBody2D = null
var power : float = 0
var setPower : bool = false
var mult : float = 1
var art : Node2D
var exploded : bool = false

func _setSpell(nspell : Spell) -> void:
	spell = nspell
	scale = Vector2.ONE * nspell.getSize() * mult

func _setPower(p : float) -> void:
	power = p
	setPower = true

func _setRadius(r : float) -> void:
	radius = r

func getDelay() -> float:
	# Delay scales inversely with spell speed
	var speed_factor = max(0.1, spell.getPSpeed())
	return delay_base / speed_factor

func _ready() -> void:
	art = $Art
	if !spell.hasElement():
		spell.components.append(Global.defaultElement)
	for i : ComponentSpellCard in spell.components:
		i.callStartEffects(self)

	# Trigger explosion after a short delay
	await get_tree().create_timer(getDelay()).timeout
	explode()

func explode() -> void:
	if exploded: return
	exploded = true

	'''# Area check
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.set_radius(radius)
	query.transform = Transform2D(0, global_position)
	query.collision_mask = 1 # Adjust as needed

	var results = space_state.intersect_shape(query, 100)

	for result in results:
		var body = result.collider
		if is_instance_valid(body) and body.has_method("_hit"):
			if body != sender and body.type != sender.type:
				body._hit(self)
				for i : ComponentSpellCard in spell.components:
					i.callHitEffects(self, body)
	'''
	
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if is_instance_valid(body) and body.has_method("_hit"):
			if body != sender and body.type != sender.type:
				body._hit(self)
				for i : ComponentSpellCard in spell.components:
					i.callHitEffects(self, body)
	
	# Cleanup
	queue_free()

func damageTaken() -> float:
	if !setPower:
		return spell.getPower() * ((mult - 1) / 2.0 + 1) * sender.getIntel()
	return power
