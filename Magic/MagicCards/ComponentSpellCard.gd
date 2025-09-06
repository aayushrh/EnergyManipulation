extends Resource
class_name ComponentSpellCard

enum{
	ELEMENT,
	AMOUNT,
	CHARGING
}

@export var spellEffects : SpellEffects
@export var cardName : String
@export var cardDescription : String
@export var hitEffects : Array[String]
@export var ongoingEffects : Array[String]
@export var startEffects : Array[String]
@export var blockEffects : Array[String]
@export var castingEffects : Array[String]
@export var OngoingVFX : PackedScene
@export var HitVFX : PackedScene
@export var StartVFX : PackedScene
@export var color : Color
@export var icon : Texture2D
@export var cdMult : float
@export var costMult : float
@export var powerMult : float
@export var attackSpeedMult : float
@export var sizeMult : float
@export var castingSpeedMult : float
@export var attribute : Array[Attributes]
@export var clashingAdvantage : float = 1.0
@export var isElement : bool

var type = 0

func callHitEffects(spellObj:SpellCasted, enemy):
	callVisualHitEffects(spellObj)
	callNonVisualHitEffects(spellObj, enemy)

func callNonVisualHitEffects(spellObj:SpellCasted, enemy):
	for e in hitEffects:
		var callable = Callable(spellEffects, e)
		callable.call(spellObj, enemy)

func callVisualHitEffects(spellObj:SpellCasted):
	if(HitVFX != null):
		var hitVFX = HitVFX.instantiate()
		if hitVFX is GPUParticles2D:
			hitVFX._setScale(spellObj.scale * 0.3)
		else:
			hitVFX.emitting = true
		hitVFX.position = spellObj.global_position
		if spellObj.get_tree() != null:
			spellObj.get_tree().current_scene.add_child(hitVFX)

func callOngoingEffects(spellObj:SpellCasted):
	if OngoingVFX != null:
		var ongoingVFX = OngoingVFX.instantiate()
		ongoingVFX.global_position = spellObj.global_position
		if spellObj.get_tree() != null:
			spellObj.get_tree().current_scene.add_child(ongoingVFX)
	for e in ongoingEffects:
		var callable = Callable(spellEffects, e)
		callable.call(spellObj)

func callStartEffects(spellObj:SpellCasted):
	if StartVFX != null:
		var startVFX = StartVFX.instantiate()
		#startVFX.global_position = spellObj.global_position
		startVFX.position = Vector2.ZERO
		spellObj.art.add_child(startVFX)
	for e in startEffects:
		var callable = Callable(spellEffects, e)
		callable.call(spellObj)

func callBlockEffects(dmgRed:float, spellObj:SpellCasted, enemy):
	for e in blockEffects:
		var callable = Callable(spellEffects, e)
		callable.call(dmgRed, spellObj, enemy)

func callCastingEffects(spellObj:SpellCast):
	for e in castingEffects:
		var callable = Callable(spellEffects, e)
		callable.call(spellObj)
