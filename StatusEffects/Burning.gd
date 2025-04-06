extends Effects
class_name Burning

var timer : float = 0.1
var dmg : float = 0.5

func _init(life : float) -> void:
	lifetime = life
	visual = load("res://Effects/Burning.tscn")
	icon = load("res://Art/flame.png")
	effectName = "Burning"
	
func _tick(entity:Node2D, delta:float) -> void:
	timer -= delta
	if(timer < 0):
		entity.health -= dmg*0.025
		timer = 0.05
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i:Node2D in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
