extends Effects
class_name Soggy

var handledEffect : bool = false

func _init(life : float) -> void:
	lifetime = life
	visual = load("res://Effects/Soggy.tscn")
	icon = load("res://Art/despair (1).png")
	effectName = "Soggy"

func _tick(entity : Node2D, delta : float) -> void:
	if !handledEffect:
		entity.TOPSPEED /= 2
		handledEffect = true
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "water":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
		entity.TOPSPEED *= 2
