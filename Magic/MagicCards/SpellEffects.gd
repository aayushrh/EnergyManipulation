extends Resource
class_name SpellEffects

@export var VortexScene : PackedScene

func testHit(spellObj:SpellCasted, enemy):
	print("hit enemy with spell")

func addBurning(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var burning = Burning.new(spellObj.spell.getPower() * 3)
		enemy.attachEffect(burning)

func addSoggy(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var soggy = Soggy.new(spellObj.spell.getPower() * 3)
		enemy.attachEffect(soggy)

func addStun(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var stun = Stun.new(spellObj.spell.getPower() * 1.5)
		enemy.attachEffect(stun)
		enemy.blocking = false

func addLightBlindness(spellObj:SpellCasted, enemy):
	if(enemy != null and !(enemy is BasicEnemy)):
		var blind = LightBlindness.new(spellObj.spell.getPower() * 100.5)
		enemy.attachEffect(blind)
	elif(enemy != null and enemy is BasicEnemy):
		var blind = Blindness.new(spellObj.spell.getPower() * 1.5)
		enemy.attachEffect(blind)

func addDarkBlindness(spellObj:SpellCasted, enemy):
	if(enemy != null and !(enemy is BasicEnemy)):
		var blind = DarkBlindness.new(spellObj.spell.getPower() * 1.5)
		enemy.attachEffect(blind)
	elif(enemy != null and enemy is BasicEnemy):
		var blind = Blindness.new(spellObj.spell.getPower() * 1.5)
		enemy.attachEffect(blind)

func lifesteal(spellObj:SpellCasted, enemy):
	if(enemy is Wall):
		return
	spellObj.sender.bonusHealBlock = true
	spellObj.sender.health += 0.5 * spellObj.spell.getPower() * spellObj.mult
	spellObj.sender.bonusHealBlock = false
	if(enemy.health > 0):
		spellObj.sender.health += 0.5 * spellObj.spell.getPower() * spellObj.mult
	else:
		spellObj.sender.health += 0.5 * (enemy.health + spellObj.damageTaken(null)) * spellObj.mult

func lightStack(dmgRed, spellObj:SpellCasted, enemy):
	if(enemy is Player and enemy.searchLight() != -1):
		enemy.health -= 0.05 * (spellObj.spell.getPower() - dmgRed) * spellObj.mult * enemy.effects[enemy.searchLight()].stack
	

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
	print(spellObj.getMousePos())

func testOngo(spellObj:SpellCasted):
	print("spell is ongoing")
