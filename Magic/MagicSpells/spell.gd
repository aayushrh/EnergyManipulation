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
	var cd = 0
	if(Constants.isValid(element)):
		match(element.spellName.to_lower()):
			"fire", "water", "electric", "light", "dark":
				cd += 3
			"nature":
				cd += 5
	if(Constants.isValid(style)):
		match(style.spellName.to_lower()):
			"dragon", "rabbit", "horse":
				cd += 5
			"boar", "monkey":
				cd += 3
			"rat":
				cd += 1
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				cd += 1
			"beam":
				cd += 3
			"shield":
				cd += 10
			"explosion":
				cd += 4
			"placed explosion":
				cd += 6
			"aura":
				cd += 30
	return cd

func getCastingTime():
	if attributes != null:
		return 1/attributes.getASpeed()
	else:
		return 0

func getMaxPowerTime():
	var t = 2
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				t *= 2.5
			"beam", "shield", "aura":
				return INF
			"explosion":
				t *= 4
			"placed explosion":
				t *= 6
	if(attributes != null):
		return t/attributes.getASpeed()
	else:
		return 0

#perfect block = 10 mana
func initCost():
	var cost = 0
	if(Constants.isValid(element)):
		match(element.spellName.to_lower()):
			"water":
				cost += 1
			"fire", "electric", "light", "dark":
				cost += 1.5
			"nature":
				cost += 3
	if(Constants.isValid(style)):
		match(style.spellName.to_lower()):
			"dragon", "rabbit":
				cost += 3
			"horse":
				cost -= 2
			"boar", "monkey":
				cost += 1
			"rat":
				cost += 0.5
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				cost += 1
			"beam":
				cost += 3
			"shield":
				cost += 5
			"explosion":
				cost += 10
			"placed explosion":
				cost += 15
			"aura":
				cost += 20
	return cost

#cost per second, 5 seconds max charge
func contcost():
	var cost = 0
	"""if(Constants.isValid(element)):
		match(element.spellName.to_lower()):
			"water":
				cost += 1
			"fire", "electric", "light", "dark":
				cost += 1.5
			"nature":
				cost += 3"""
	if(Constants.isValid(style)):
		match(style.spellName.to_lower()):
			"dragon", "rabbit":
				cost += 0
			"horse":
				cost -= 0.5
			"boar", "monkey":
				cost += 0
			"rat":
				cost += 0
	if(Constants.isValid(type)):
		match(type.spellName.to_lower()):
			"blast":
				cost += 1
			"beam":
				cost += 4
			"shield":
				cost += 10
			"explosion":
				cost += 3
			"placed explosion":
				cost += 5
			"aura":
				cost += 100
	return cost
