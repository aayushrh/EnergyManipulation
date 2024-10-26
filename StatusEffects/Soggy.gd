extends Effects
class_name Soggy

var handledEffect = false

func _init(life):
	lifetime = life
	visual = load("res://Effects/Soggy.tscn")

func _tick(entity):
	print("soggyness")
	if !handledEffect:
		entity.TOPSPEED /= 2
		handledEffect = true
	lifetime -= 1
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i in entity.vfx:
			if i.vfxName.to_lower() == "water":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
		entity.TOPSPEED *= 2
