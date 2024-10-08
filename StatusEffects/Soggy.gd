extends Effects

var handledEffect = false

func _tick(entity):
	if !handledEffect:
		entity.TOPSPEED /= 2
	lifetime -= 1
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		entity.TOPSPEED *= 2
