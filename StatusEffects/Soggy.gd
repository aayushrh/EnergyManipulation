extends Effects
class_name Soggy

var stack := 1.0
var base := 1.5
var baselog := log(base)

func _init(life : float) -> void:
	stackable = true
	lifetime = life
	visual = load("res://Effects/Soggy.tscn")
	icon = load("res://Art/despair (1).png")
	effectName = "Soggy"

func _tick(entity : Node2D, delta : float) -> void:
	entity.speedModifier = baselog/log(lifetime + base)
	stack = snapped(lifetime, 0.1)
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "water":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
		entity.speedModifier = 1.0

func _stack(entity : Effects) -> void:
	if(entity.effectName == effectName):
		lifetime = max(lifetime, entity.lifetime) + min(lifetime, entity.lifetime)/2
	else:
		push_error("We fucked up somehow(WaterStacks)")
