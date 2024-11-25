extends Node
class_name Spell

var element : ElementSpellCard
var style : StyleSpellCard
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

func resetCooldown(use):
	cooldown = getcd()
	using = use

func getcd():
	var cd = 1
	if(element != null):
		cd *= element.cdMult
	if(style != null):
		cd *= style.cdMult
	if(type != null):
		cd *= type.cdMult
	return cd

func getCastingTime():
	var time = 1
	if(type != null):
		time *= type.castingTimeMult
	return time

func getMaxPowerTime():
	var time = 1
	if(type != null):
		time *= type.maxPowerTimeMult
	return time

#perfect block = 10 mana
func initCost():
	var cost = 1
	if(element != null):
		cost *= element.costMult
	if(style != null):
		cost *= style.costMult
	if(type != null):
		cost *= type.costMult
	return cost

#total cost for max charge expect for holdings
func contcost():
	var cost = 1
	if(element != null):
		cost *= element.costMult
	if(style != null):
		cost *= style.costMult
	if(type != null):
		cost *= type.contCostMult
	return cost

func getPower():
	if(element != null):
		return attributes.getPower() * element.powerMult
	return attributes.getPower()

func getPSpeed():
	if(element != null):
		return attributes.getPSpeed() * element.attackSpeedMult
	return attributes.getPSpeed()

func getASpeed():
	if(element != null):
		return attributes.getASpeed() * element.castingSpeedMult
	return attributes.getASpeed()

func getSize():
	if(element != null):
		return attributes.getSize() * element.sizeMult
	return attributes.getSize()

func getAmount():
	return attributes.getAmount()
