extends Effects
class_name Burning

var timer = 60

func _init(life):
	lifetime = life
	visual = load("res://Effects/Burning.tscn")

func _tick(entity, delta):
	timer -= 1
	if(timer < 0):
		entity.health -= 0.5
		timer = 60
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
