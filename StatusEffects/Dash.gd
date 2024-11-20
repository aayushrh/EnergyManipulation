extends Effects
class_name Dash

var handledEffect = false

func _init(life):
	lifetime = life
	visual = load("res://Effects/Tired.tscn")
	icon = load("res://Art/sprint.png")

func _tick(entity, delta):
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i in entity.vfx:
			if i.vfxName.to_lower() == "dash":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
