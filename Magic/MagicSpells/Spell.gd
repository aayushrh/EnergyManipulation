extends Node
class_name Spell

var components : Array[ComponentSpellCard]
var type : TypeSpellCard
var attributes: Array[Array] #Array[Array[AttributesWrapper]]
var spellName : String = ""
var binding : int = -1
var cooldown : float = 0
var using : bool = false
var slow : bool = true
var intel : float = 1.0

func create() -> Spell:
	var newSpell : Spell = Spell.new(spellName)
	for i : ComponentSpellCard in components:
		newSpell.components.append(i)
	newSpell.type = type
	newSpell.binding = binding
	newSpell.cooldown = cooldown
	newSpell.using = using
	newSpell.intel = intel
	for arr : Array[AttributesWrapper] in attributes:
		var x : Array[AttributesWrapper] = []
		for i : AttributesWrapper in arr:
			x.append(i)
		newSpell.attributes.append(x)
	return newSpell

func _init(namen:String) -> void:
	spellName = namen

func _cast(sender:CharacterBody2D) -> SpellCast:
	if(type != null):
		intel *= sender.getIntel()
		var cast : SpellCast = type.SpellObj.instantiate()
		cast.sender = sender
		var dupe : Spell = create()
		#if(dupe.element == null):
			#dupe.element = sender.get_tree().current_scene.defaultElement
		cast.setSpell(dupe)
		cast.global_position = sender.global_position
		sender.get_tree().current_scene.add_child(cast)
		cast.connect("done", _notUsing)
		return cast
	else:
		_notUsing()
		cooldown = 0
		return null

func _notUsing() -> void:
	using = false

func resetCooldown(use:bool, multi:float) -> void:
	cooldown = getcd()*multi
	using = use

func getcd() -> float:
	var cd : float = 3 * getAttrScaled("Cooldown")
	if(components != null):
		for i : ComponentSpellCard in components:
			cd *= i.cdMult
	if(type != null):
		cd *= type.cdMult
	return cd / pow(intel,0.5)

func getCastingTime() -> float:
	var time : float = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.castingTimeMult
	return time / pow(intel,0.5)

func getMaxPowerTime() -> float:
	var time : float = 1.25
	if(components != null):
		for i:ComponentSpellCard in components:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.maxPowerTimeMult
	return time / pow(intel,0.5)

#perfect block = 10 mana
func initCost() -> float:
	var cost : float = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			cost *= i.costMult
	if(type != null):
		cost *= type.costMult
	return cost / pow(intel,0.25)

#total cost for max charge expect for holdings
func contcost() -> float:
	var cost: float = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			cost *= i.costMult
	if(type != null):
		cost *= type.contCostMult
	return cost / pow(intel,0.25)

func getAttr(nname : String) -> Array[float]:
	var returnval : Array[float] = []
	var x = nname.to_lower()
	for arr : Array[AttributesWrapper] in attributes:
		for i : AttributesWrapper in arr:
			if(i.d.has(x)):
				returnval.append(i.d[x]["value"])
	return returnval

func getAttrScaled(nname : String) -> float:
	var r = 1.0
	for i in getAttr(nname):
		r *= i
	return r

func getPower() -> float:
	var p : float = getAttrScaled("Power")
	if(components != null):
		for i:ComponentSpellCard in components:
			p *= i.powerMult
	return p * intel

func getPoison() -> float:
	for c in components:
		if (c.cardName == "Nature"):
			return 0
	return 1

func getPSpeed() -> float:
	var ps : float = getAttrScaled("Projectile_Speed")
	if(components != null):
		for i:ComponentSpellCard in components:
			ps *= i.attackSpeedMult
	return ps * pow(intel,0.5)

func getASpeed() -> float:
	var cs : float = getAttrScaled("Casting_Speed")
	if(components != null):
		for i:ComponentSpellCard in components:
			cs *= i.castingSpeedMult
	return cs * pow(intel,0.5)

func getSize() -> float:
	var s : float = getAttrScaled("Size")
	if(components != null):
		for i:ComponentSpellCard in components:
			s *= i.sizeMult
	return s * pow(intel,0.25)

func hasElement() -> bool:
	for i:ComponentSpellCard in components:
		if i.isElement:
			return true
	return false

func getAmt(x: String) -> float:
	var r = 1
	for i in getAttr(x):
		r += i
	return r

func getAmount() -> float:
	return getAmt("Amount")

func getCluster() -> float:
	return getAmt("Cluster")

func getShrapnel() -> float:
	return getAmt("Shrapnel") - 1

func getClashingAdvantage() -> float:
	var a : int = getAttrScaled("Clash")
	var c :float = 1.0
	if(components != null):
		for i:ComponentSpellCard in components:
			c *= i.clashingAdvantage
	return c * intel
