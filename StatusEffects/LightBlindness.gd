extends Effects
class_name LightBlindness

var handledEffect : bool = false
var stack : int = 1
var lifeTimeStack : Array[float] = []

func _init(life : float) -> void:
	stackable = true
	lifetime = life
	visual = load("res://Effects/LightBlindness.tscn")
	icon = load("res://Art/sight-disabled.png")
	effectName = "Light"
	enemyShows = false

func _tick(entity : Node2D, delta : float) -> void:
	#if !handledEffect:
		#entity.TOPSPEED /= 2
		#handledEffect = true
	if(stack != lifeTimeStack.size() + 1):
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "light":
				stack = lifeTimeStack.size() + 1
				i.stack = stack
	lifetime -= delta
	if lifetime <= 0:
		if(lifeTimeStack.size() == 0):
			entity.effects.remove_at(entity.effects.find(self))
			for i : Node2D in entity.vfx:
				if i.vfxName.to_lower() == "light":
					entity.vfx.remove_at(entity.vfx.find(i))
					i.queue_free()
					break
		else:
			lifetime = lifeTimeStack[0]
			lifeTimeStack.remove_at(0)
		#entity.TOPSPEED *= 2
