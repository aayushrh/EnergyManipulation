extends Effects
class_name DarkBlindness

var handledEffect = false

func _init(life):
	lifetime = life
	visual = load("res://Effects/DarkBlindness.tscn")
	icon = load("res://Art/despair (1).png")
	effectName = "Darkness"

func _tick(entity, delta):
	#if !handledEffect:
		#entity.TOPSPEED /= 2
		#handledEffect = true
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i in entity.vfx:
			if i.vfxName.to_lower() == "dark":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
		#entity.TOPSPEED *= 2
