extends Effects
class_name DarkBlindness

var handledEffect = false
var stack = 1
var lifeTimeStack = []

func _init(life):
	stackable = true
	lifetime = life
	visual = load("res://Effects/DarkBlindness.tscn")
	icon = load("res://Art/sight-disabled (1).png")
	effectName = "Darkness"

func _tick(entity, delta):
	if(stack != lifeTimeStack.size() + 1):
		for i in entity.vfx:
			if i.vfxName.to_lower() == "dark":
				stack = lifeTimeStack.size() + 1
				i.stack = stack
	lifetime -= delta
	if lifetime <= 0:
		if(lifeTimeStack.size() == 0):
			entity.effects.remove_at(entity.effects.find(self))
			for i in entity.vfx:
				if i.vfxName.to_lower() == "dark":
					entity.vfx.remove_at(entity.vfx.find(i))
					i.queue_free()
					break
		else:
			lifetime = lifeTimeStack[0]
			lifeTimeStack.remove_at(0)
		#entity.TOPSPEED *= 2
