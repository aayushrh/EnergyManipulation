extends Resource
class_name SpellEffects

@export var VortexScene : PackedScene

func testHit(spellObj:SpellCasted, enemy):
	print("hit enemy with spell")

func addBurning(dmgRed, spellObj:SpellCasted, enemy):
	if(enemy != null && dmgRed < 1):
		var burning = Burning.new((1.0 - dmgRed) * 2.5, spellObj.spell.getPower())
		enemy.attachEffect(burning, false)

func addSoggy(dmgRed, spellObj:SpellCasted, enemy):
	if(enemy != null && dmgRed < 1):
		var soggy = Soggy.new((spellObj.spell.getPower() * (1.0 - dmgRed)) * 3)
		enemy.attachEffect(soggy, false)

func addStun(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var stun = Stun.new(spellObj.spell.getPower() * 1.5)
		enemy.attachEffect(stun)
		enemy.blocking = false

func addLightBlindness(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var blind = LightBlindness.new(spellObj.spell.getPower() * 7.5)
		enemy.attachEffect(blind)
	"""elif(enemy != null and enemy is BasicEnemy):
		var blind = Blindness.new(spellObj.spell.getPower() * 7.5)
		enemy.attachEffect(blind)"""

func addDarkBlindness(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var blind = DarkBlindness.new(spellObj.spell.getPower() * 7.5)
		enemy.attachEffect(blind)
	"""elif(enemy != null and enemy is BasicEnemy):
		var blind = Blindness.new(spellObj.spell.getPower() * 7.5)
		enemy.attachEffect(blind)"""

func lifesteal(dmgRed, spellObj:SpellCasted, enemy):
	if(!is_instance_valid(spellObj.sender) || enemy is Wall || dmgRed >= 1):
		return
	spellObj.sender.bonusHealBlock = true
	spellObj.sender.health += 0.5 * spellObj.spell.getPower() * spellObj.mult
	spellObj.sender.bonusHealBlock = false
	if(enemy.health > 0):
		spellObj.sender.health += 0.5 * (spellObj.spell.getPower() * (1.0 - dmgRed)) * spellObj.mult
	else:
		spellObj.sender.health += 0.5 * (enemy.health + spellObj.damageTaken() * (1.0 - dmgRed)) * spellObj.mult

func lightStack(dmgRed, spellObj:SpellCasted, enemy):
	if(enemy is Wall || dmgRed >= 1):
		return
	if(enemy.searchLight() != -1):
		enemy.health -= 0.05 * (spellObj.spell.getPower() * (1.0 - dmgRed)) * spellObj.mult * enemy.effects[enemy.searchLight()].stack
	

func takeHealth(spellObj:SpellCasted):
	if(spellObj.sender is BasicEnemy):
		spellObj.sender.fuck = true
	if(!spellObj.combined):
		if(spellObj.sender.health > 0.5 * spellObj.spell.getPower() * spellObj.mult):
			spellObj.sender.health -= 0.5 * spellObj.spell.getPower() * spellObj.mult
		else:
			spellObj.sender.health = 0.001

func unbound(spellObj:SpellCast):
	spellObj.slow = false

func addVortex(spellObj:SpellCasted):
	var vortex = VortexScene.instantiate()
	vortex._setSpell(spellObj.spell, spellObj.sender.type)
	spellObj.add_child(vortex)

func giveBackHP(dmgRed, spellObj, enemy):
	if(is_instance_valid(spellObj) and spellObj.sender is BasicEnemy):
		spellObj.sender.fuck = true
	spellObj.sender.health -= spellObj.spell.getPower() * dmgRed

func giveBackEnergy(spellObj:SpellCasted):
	spellObj.sender.stored_energy += 0.25 * (spellObj.spell.initCost() + spellObj.castingCost)

func changePosToMouse(spellObj: SpellCast):
	spellObj.setStartingLoc(spellObj.getMousePos())

func testOngo(spellObj:SpellCasted):
	print("spell is ongoing")
