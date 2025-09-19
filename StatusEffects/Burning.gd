extends Effects
class_name Burning

var handledEffect : bool = false
var stack : int = 1
var lifeTimeStack : Array[float] = []
var dmgStack : Array[float] = [0.5]
var timer := 0.1

func _init(life : float, power : float) -> void:
	stackable = true
	lifetime = life * 1.25
	dmgStack = [0.0125 * power / 1.5]
	visual = load("res://Effects/Burning.tscn")
	icon = load("res://Art/flame.png")
	effectName = "Burning"
	
func _tick(entity:Node2D, delta:float) -> void:
	if(stack != lifeTimeStack.size() + 1):
		print("Adding fire")
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				stack = lifeTimeStack.size() + 1
				i.stack = stack
	lifetime -= delta
	timer -= delta
	if(timer <= 0):
		take_dmg(entity)
	if lifetime <= 0:
		if(lifeTimeStack.size() == 0):
			entity.effects.remove_at(entity.effects.find(self))
			for i : Node2D in entity.vfx:
				if i.vfxName.to_lower() == "fire":
					entity.vfx.remove_at(entity.vfx.find(i))
					i.queue_free()
					break
		else:
			lifetime = lifeTimeStack[0]
			lifeTimeStack.remove_at(0)
			dmgStack.remove_at(0)

func take_dmg(entity:Node2D) -> void:
	for d in dmgStack:
		entity.health -= d
	timer = 0.1

func _stack(entity : Effects) -> void:
	if(entity.effectName == effectName):
		print("Attempting to stack fire")
		lifeTimeStack.append(entity.lifetime)
		dmgStack = dmgStack + entity.dmgStack
	else:
		push_error("We fucked up somehow(FireStacks)")
