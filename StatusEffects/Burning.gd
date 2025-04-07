extends Effects
class_name Burning

var timer : float = 0.1
var dmg : float = 0.5

func _init(life : float, power : float) -> void:
	lifetime = life
	dmg = 0.025 * power
	visual = load("res://Effects/Burning.tscn")
	icon = load("res://Art/flame.png")
	effectName = "Burning"
	
func _tick(entity:Node2D, delta:float) -> void:
	timer -= delta
	lifetime -= delta
	if lifetime <= 0:
		take_dmg(entity)#at least one hit gets in lmao
		entity.effects.remove_at(entity.effects.find(self))
		for i:Node2D in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				return
	if(timer < 0):
		take_dmg(entity)

func take_dmg(entity):
	entity.health -= dmg
	timer = 0.1
