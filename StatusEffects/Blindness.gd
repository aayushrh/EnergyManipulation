extends Effects
class_name Blindness

var handledEffect = false

func _init(life):
	lifetime = life
	visual = load("res://Effects/Soggy.tscn")
	icon = load("res://Art/despair (1).png")
	effectName = "Blind"

func _tick(entity, delta):
	if !handledEffect:
		entity.blinded = true
		handledEffect = true
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i in entity.vfx:
			if i.vfxName.to_lower() == "water":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
		entity.blinded = false
