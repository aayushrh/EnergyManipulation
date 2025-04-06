extends Effects
class_name Stun

var handledEffect : bool = false

func _init(life : float) -> void:
	lifetime = life
	visual = load("res://Effects/Stunned.tscn")
	icon = load("res://Art/stoned-skull.png")
	effectName = "Stun"

func _tick(entity : Node2D, delta : float) -> void:
	if !handledEffect:
		entity.pause = true
	lifetime -= delta
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "stun":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
		entity.pause = false
