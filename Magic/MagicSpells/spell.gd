extends Node2D
class_name Spell

var element = null
var style = null
var attributes = null
var type = null
var spellName = ""
var binding = null
var cooldown = 0
var using = false

func _init(namen):
	spellName = namen
	attributes = Attributes.new(0.0, 0.0, 1.0)

func resetCooldown(use):
	cooldown = getcd()
	using = use

func getcd():
	var cd = 1
	if(Constants.isValid(element)):
		cd *= 1
	else:
		cd *= 0.5
	if(Constants.isValid(style)):
		cd *= 1.5
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"beam":
				cd *= 5
			"shield":
				cd *= 30
			"explosion":
				cd *= 2
			"placed explosion":
				cd *= 5
			"aura":
				cd *= 60
	return cd

func getCastingTime():
	var time = 1
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				time *= 0.5
			"beam":
				time *= 0.2
			"shield":
				time *= 0.3
			"explosion":
				time *= 0.75
			"placed explosion":
				time *= 1
			"aura":
				time *= 2
	return time

func getMaxPowerTime():
	var t = 1
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				t *= 1.5
			"beam", "shield", "aura":
				return INF
			"explosion":
				t *= 2.25
			"placed explosion":
				t *= 3
	if(attributes != null):
		return t/attributes.getASpeed()
	else:
		return 0

#perfect block = 10 mana
func initCost():
	var cost = 1
	if(Constants.isValid(element)):
		cost *= 1
	else:
		cost *= 2
	if(Constants.isValid(style)):
		cost *= 1.5
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				cost *= 5
			"beam":
				cost *= 4
			"shield":
				cost *= 4
			"explosion":
				cost *= 7
			"placed explosion":
				cost *= 10
			"aura":
				cost *= 20
	return cost

#total cost for max charge expect for holdings
func contcost():
	var cost = 1
	if(Constants.isValid(element)):
		cost *= 1
	else:
		cost *= 2
	if(Constants.isValid(style)):
		cost *= 1.5
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				cost *= 3
			"beam":
				cost *= 5
			"shield":
				cost *= 1
			"explosion":
				cost *= 3
			"placed explosion":
				cost *= 5
			"aura":
				cost *= 2
	return cost
