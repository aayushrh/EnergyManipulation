extends Resource
class_name SpellEffects

func testHit(spellObj:SpellCasted, enemy):
	print("hit enemy with spell")

func addBurning(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var burning = Burning.new(3)
		enemy.attachEffect(burning)

func addSoggy(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var soggy = Soggy.new(3)
		enemy.attachEffect(soggy)

func addStun(spellObj:SpellCasted, enemy):
	if(enemy != null):
		var stun = Stun.new(1.5)
		enemy.attachEffect(stun)

func lifesteal(spellObj:SpellCasted, enemy):
	if(enemy.health > 0):
		spellObj.sender.health += 0.1 * spellObj.spell.attributes.getPower()

func giveBackEnergy(spellObj:SpellCasted):
	spellObj.player.stored_energy += 0.36 * (spellObj.spell.initCost() + spellObj.castingCost)

func testOngo(spellObj:SpellCasted):
	print("spell is ongoing")
