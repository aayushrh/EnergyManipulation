extends Node
class_name Spell

var components : Array[ComponentSpellCard]
var type : TypeSpellCard
var attributes: Array[AttributesWrapper]
var spellName : String = ""
var binding : int = -1
var cooldown : float = 0
var using : bool = false
var slow : bool = true

func create() -> Spell:
	var newSpell : Spell = Spell.new(spellName)
	for i : ComponentSpellCard in components:
		newSpell.components.append(i)
	newSpell.type = type
	newSpell.binding = binding
	newSpell.cooldown = cooldown
	newSpell.using = using
	for i:AttributesWrapper in attributes:
		newSpell.attributes.append(i)
	return newSpell

func _init(namen:String) -> void:
	spellName = namen

func _cast(sender:CharacterBody2D) -> SpellCast:
	if(type != null):
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
	var cd : float = 3
	if(components != null):
		for i : ComponentSpellCard in components:
			cd *= i.cdMult
	if(type != null):
		cd *= type.cdMult
	return cd

func getCastingTime() -> float:
	var time : float = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.castingTimeMult
	return time

func getMaxPowerTime() -> float:
	var time : float = 1.25
	if(components != null):
		for i:ComponentSpellCard in components:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.maxPowerTimeMult
	return time

#perfect block = 10 mana
func initCost() -> float:
	var cost : float = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			cost *= i.costMult
	if(type != null):
		cost *= type.costMult
	return cost

#total cost for max charge expect for holdings
func contcost() -> float:
	var cost: float = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			cost *= i.costMult
	if(type != null):
		cost *= type.contCostMult
	return cost

func getAttr(nname : String) -> float:
	for i:AttributesWrapper in attributes:
		if(i.attr.Ltext == nname):
			return i.leftvalue
		if(i.attr.Rtext == nname):
			return i.rightvalue
	return 50

func getSupreme() -> float:
	var r = 1.0
	for i:AttributesWrapper in attributes:
		if(i.attr.Ltext == "Supreme"):
			r *= (i.leftvalue + 100.0)/(100.0)
		if(i.attr.Rtext == "Supreme"):
			r *= (i.rightvalue + 100.0)/(100.0)
	return r

func getAttrScaled(nname : String) -> float:
	var n : float = (getAttr(nname) + 50.0)/100.0
	return n

func getPower() -> float:
	var p : float = (getAttr("Power") + 100.0)/100.0
	print("Power is: " + str(p))
	if(components != null):
		for i:ComponentSpellCard in components:
			p *= i.powerMult
	return p * getSupreme()

func getPSpeed() -> float:
	var ps = (getAttr("Proj. Spd.") + 100.0)/100.0
	print("ps is : " + str(ps))
	if(components != null):
		for i:ComponentSpellCard in components:
			ps *= i.attackSpeedMult
			print("ps for atackSpeed is : " + str(i.attackSpeedMult))
	return ps * (1.0+getSupreme())/2

func getASpeed() -> float:
	var cs = (getAttr("Cast. Spd.") + 100.0)/100.0
	if(components != null):
		for i:ComponentSpellCard in components:
			cs *= i.castingSpeedMult
	return cs * getSupreme()

func getSize() -> float:
	var s = (getAttr("Size") + 100.0)/100.0
	if(components != null):
		for i:ComponentSpellCard in components:
			s *= i.sizeMult
	return s * getSupreme()

func hasElement() -> bool:
	for i:ComponentSpellCard in components:
		if i.isElement:
			return true
	return false

func getAmount() -> float:
	var a = getAttr("Amount")
	if a != 50:
		return a
	return 1

func getClashingAdvantage() -> float:
	var c = 1
	if(components != null):
		for i:ComponentSpellCard in components:
			c *= i.clashingAdvantage
	return c
