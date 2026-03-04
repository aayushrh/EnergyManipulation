extends SpellCasted
class_name Shield

static var idTotal = 0

var id = -1
var speed : float = 100.0
var mult : float = 1
var sender : CharacterBody2D = null
var segSize : float = 0.0
var angleOffset : float = 0.0
var art

var ShieldCast := preload("res://Magic/MagicCasts/ShieldCast.tscn")

func _setSpell(nspell : Spell) -> void:
	spell = nspell

func _ready() -> void:
	art = $Art
	
	if id == -1:
		id = idTotal
		idTotal += 1
	
	if !spell.hasElement():
		spell.components.append(Global.defaultElement)
	for i : ComponentSpellCard in spell.components:
		i.callStartEffects(self)

func _physics_process(delta : float) -> void:
	delta *= Global.getTimeScale()
	angleOffset += delta * spell.getPSpeed() * speed
	
	for i : ComponentSpellCard in spell.components:
		i.callOngoingEffects(self)
	
	global_position = sender.global_position

func _on_area_2d_area_entered(area : Area2D) -> void:
	var body := area.get_parent()
	if(body is Blast and is_instance_valid(body.sender) and is_instance_valid(sender) and body.sender.type != sender.type):
		for i : ComponentSpellCard in spell.components:
			i.callVisualHitEffects(self)
		for i : ComponentSpellCard in body.spell.components:
			i.callVisualHitEffects(self)
		body.queue_free()

func _draw():
	var x = segSize
	var angleLen = (200 * pow(x, (1/3)))/((pow(x, (1/3)) + 1) * spell.getAmount())
	
	for i in range(spell.getAmount()):
		draw_arc(Vector2.ZERO, 75, (i * 360/spell.getAmount() - angleLen/2 + angleOffset)*(PI/180), (i * 360/spell.getAmount() + angleLen/2 + angleOffset)*(PI/180), 20, Color(1, 1, 1, 1), 5)
