extends Resource
class_name ElementSpellCard

@export var spellEffects : SpellEffects
@export var cardName : String
@export var cardDescription : String
@export var hitEffects : Array[String]
@export var ongoingEffects : Array[String]
@export var startEffects : Array[String]
@export var OngoingVFX : PackedScene
@export var HitVFX : PackedScene
@export var StartVFX : PackedScene
@export var color : Color
@export var icon : Texture2D
@export var cdMult : float
@export var costMult : float
var type = 0

func callHitEffects(spellObj:SpellCasted, enemy):
	var hitVFX = HitVFX.instantiate()
	hitVFX.emitting = true
	hitVFX.position = spellObj.global_position
	if spellObj.get_tree() != null:
		spellObj.get_tree().current_scene.add_child(hitVFX)
	for e in hitEffects:
		var callable = Callable(spellEffects, e)
		callable.call(spellObj, enemy)

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
		spellObj.add_child(startVFX)
	for e in startEffects:
		var callable = Callable(spellEffects, e)
		callable.call(spellObj)
