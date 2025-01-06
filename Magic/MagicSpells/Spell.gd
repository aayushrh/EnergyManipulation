extends Node
class_name Spell

var element : Array[ElementSpellCard]
var style : Array[StyleSpellCard]
var type : TypeSpellCard
var spellName = ""
var attributes = null
var binding = null
var cooldown = 0
var using = false

func create():
	var newSpell = Spell.new(spellName)
	newSpell.element = element
	newSpell.style = style
	newSpell.type = type
	newSpell.attributes = attributes
	newSpell.binding = binding
	newSpell.cooldown = cooldown
	newSpell.using = using
	return newSpell

func _init(namen):
	spellName = namen
	attributes = Attributes.new(0.0, 0.0, 1.0)

func _cast(player):
	if(type != null):
		var cast = type.SpellObj.instantiate()
		cast.player = player
		var dupe = create()
		if(dupe.element == null):
			dupe.element = player.get_tree().current_scene.defaultElement
		cast.setSpell(dupe)
		cast.global_position = player.global_position
		player.get_tree().current_scene.add_child(cast)
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
	if(element != null):
		for i in element:
			cd *= i.cdMult
	if(style != null):
		for i in style:
			cd *= i.cdMult
	if(type != null):
		cd *= type.cdMult
	return cd

func getCastingTime():
	var time = 1
	if(element != null):
		for i in element:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.castingTimeMult
	return time

func getMaxPowerTime():
	var time = 1
	if(element != null):
		for i in element:
			time *= 1/i.castingSpeedMult
	if(type != null):
		time *= type.maxPowerTimeMult
	return time

#perfect block = 10 mana
func initCost():
	var cost = 1
	if(element != null):
		for i in element:
			cost *= i.costMult
	else:
		cost *= 2
	if(style != null):
		for i in style:
			cost *= i.costMult
	if(type != null):
		cost *= type.costMult
	return cost

#total cost for max charge expect for holdings
func contcost():
	var cost = 1
	if(element != null):
		for i in element:
			cost *= i.costMult
	if(style != null):
		for i in style:
			cost *= i.costMult
	if(type != null):
		cost *= type.contCostMult
	return cost

func getPower():
	if(element != null):
		var power = attributes.getPower()
		for i in element:
			power *= i.powerMult
		return power
	return attributes.getPower()

func getPSpeed():
	if(element != null):
		var pSpeed = attributes.getPSpeed()
		for i in element:
			pSpeed *= i.attackSpeedMult
		return pSpeed
	return attributes.getPSpeed()

func getASpeed():
	if(element != null):
		var cspeed = attributes.getASpeed()
		for i in element:
			cspeed *= i.castingSpeedMult
		return cspeed
	return attributes.getASpeed()

func getSize():
	if(element != null):
		var size = attributes.getSize()
		for i in element:
			size *= i.sizeMult
		return size
	return attributes.getSize()

func getAmount():
	return attributes.getAmount()
