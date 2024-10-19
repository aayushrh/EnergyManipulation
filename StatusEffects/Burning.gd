extends Effects
class_name Burning

var timer = 10

func _init(life):
	lifetime = life

func _tick(entity):
	timer -= 1
	if(timer < 0):
		entity.health -= 1
		timer = 10
	lifetime -= 1
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
