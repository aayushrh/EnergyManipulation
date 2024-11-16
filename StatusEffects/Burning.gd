extends Effects
class_name Burning

var timer = 0.1
var dmg = 0.5

func _init(life):
	lifetime = life
	visual = load("res://Effects/Burning.tscn")
	icon = load("res://Art/flame.png")
	
func _tick(entity, delta):
	timer -= delta
	if(timer < 0):
		entity.health -= dmg*0.025
		timer = 0.05
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
