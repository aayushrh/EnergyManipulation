extends Node
class_name Spell

var components : Array[ComponentSpellCard]
var type : TypeSpellCard
var attributes: Array[AttributesWrapper]
var spellName = ""
var binding = null
var cooldown = 0
var using = false
var power = 1.0
var pSpeed = 1.0
var size = 1.0
var cSpeed = 1.0

func create():
	var newSpell = Spell.new(spellName)
	for i in components:
		newSpell.components.append(i)
	newSpell.type = type
	newSpell.binding = binding
	newSpell.cooldown = cooldown
	newSpell.using = using
	for i in attributes:
		newSpell.attributes.append(i)
	return newSpell

func _init(namen):
	spellName = namen

func _cast(sender):
	if(type != null):
		var cast = type.SpellObj.instantiate()
		cast.sender = sender
		var dupe = create()
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

func _notUsing():
	using = false

func resetCooldown(use, multi):
	cooldown = getcd()*multi
	using = use

func getcd():
	var cd = 1
	if(components != null):
		for i in components:
			cd *= i.cdMult
	if(type != null):
		cd *= type.cdMult
	return cd

func getCastingTime():
	var time = 1
	if(components != null):
		for i in components:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.castingTimeMult
	return time

func getMaxPowerTime():
	var time = 1
	if(components != null):
		for i in components:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.maxPowerTimeMult
	return time

#perfect block = 10 mana
func initCost():
	var cost = 1
	if(components != null):
		for i in components:
			cost *= i.costMult
	if(type != null):
		cost *= type.costMult
	return cost

#total cost for max charge expect for holdings
func contcost():
	var cost = 1
	if(components != null):
		for i in components:
			cost *= i.costMult
	if(type != null):
		cost *= type.contCostMult
	return cost

func getAttr(name):
	for i in attributes:
		if(i.attr.Ltext == name):
			return i.leftvalue
		if(i.attr.Rtext == name):
			return i.rightvalue
	return 50

func getPower():
	var p = (getAttr("Power") + 50.0)/100.0
	print("Power is: " + str(p))
	if(components != null):
		for i in components:
			p *= i.powerMult
	return p

func getPSpeed():
	var ps = (getAttr("Proj. Spd.") + 50.0)/100.0
	if(components != null):
		for i in components:
			ps *= i.attackSpeedMult
	return ps

func getASpeed():
	var cs = (getAttr("Cast. Spd.") + 50.0)/100.0
	if(components != null):
		for i in components:
			cs *= i.castingSpeedMult
	return cs

func getSize():
	var s = (getAttr("Size") + 50.0)/100.0
	if(components != null):
		for i in components:
			s *= i.sizeMult
	return s

func hasElement():
	for i in components:
		if i.isElement:
			return true
	return false

func getAmount():
	return 1
