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
var explosionTimer : float = 0
var combined : bool = false
var castingCost : float = 0.0

func _setSpell(nspell : Spell) -> void:
	spell = nspell
	scale = Vector2(1.5, 1.5) * nspell.getSize() * mult

func _ready() -> void:
	art = $Art
	if !spell.hasElement():
		spell.components.append(Global.defaultElement)
	for i : ComponentSpellCard in spell.components:
		i.callStartEffects(self)
	$Art.redy()
	explosionTimer = 0.2/spell.getPSpeed()

func _process(delta):
	explosionTimer -= delta * Global.getTimeScale()
	if explosionTimer < 0:
		explode()

func explode() -> void:
	if exploded: return
	exploded = true
	
	var bodies : Array[Node2D] = $Area2D.get_overlapping_bodies()
	
	for i : ComponentSpellCard in spell.components:
		i.callVisualHitEffects(self)
	
	if bodies.size() > 0:
		get_tree().current_scene.amountHit += 1
		get_tree().current_scene.multiHits -= 1
	
	for body : Node2D in bodies:
		get_tree().current_scene.multiHits += 1
		if is_instance_valid(body) and body.has_method("_hit"):
			if body != sender and body.type != sender.type:
				body._hit(self)
				for i : ComponentSpellCard in spell.components:
					i.callNonVisualHitEffects(self, body)
	
	# Cleanup
	queue_free()

func damageTaken() -> float:
	if !setPower:
		return spell.getPower() * ((mult - 1) / 2.0 + 1) * sender.getIntel()
	return power
