extends Node
class_name Spell

var element : Array[ElementSpellCard]
var style : Array[StyleSpellCard]
var type : TypeSpellCard
var attributes: Array[AttributesWrapper]
var spellName = ""
var binding = null
var cooldown = 0
var using = false
var power = 0.0
var pSpeed = 0.0
var size = 0.0
var cSpeed = 0.0

func create():
	var newSpell = Spell.new(spellName)
	newSpell.element = element
	newSpell.style = style
	newSpell.type = type
	newSpell.binding = binding
	newSpell.cooldown = cooldown
	newSpell.using = using
	return newSpell

func _init(namen):
	spellName = namen

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
	var p = power
	if(element != null):
		for i in element:
			p *= i.powerMult
	return p

func getPSpeed():
	var ps = pSpeed
	if(element != null):
		for i in element:
			ps *= i.attackSpeedMult
	return ps

func getASpeed():
	var cs = cSpeed
	if(element != null):
		for i in element:
			cs *= i.castingSpeedMult
	return cs

func getSize():
	var s = size
	if(element != null):
		for i in element:
			s *= i.sizeMult
	return s
