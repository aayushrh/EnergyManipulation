extends Effects
class_name Burning

var handledEffect : bool = false
var stack : int = 1
var lifeTimeStack : Array[float] = []
var dmgStack : Array[float] = [0.5]
var timer := 0.1

func _init(life : float, power : float) -> void:
	stackable = true
	lifeTimeStack = [life * .75]
	dmgStack = [0.025 * power]
	visual = load("res://Effects/Burning.tscn")
	icon = load("res://Art/flame.png")
	effectName = "Burning"
	
func _tick(entity:Node2D, delta:float) -> void:
	if(stack != lifeTimeStack.size()):
		print("Adding fire")
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				stack = lifeTimeStack.size()
				i.stack = stack
	timer -= delta
	if(timer <= 0):
		take_dmg(entity)
	tick_lifeTime(delta)
	if lifetime <= 0 or len(lifeTimeStack) == 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "fire":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
func take_dmg(entity:Node2D) -> void:
	for d in dmgStack:
		entity.commit_dmg(-d, {"type": "burn", "color": Color(1, 0.5, 0)})
			
	timer = 0.1

func tick_lifeTime(delta:float):
	
	for l in len(lifeTimeStack):
		lifeTimeStack[l] -= delta
		lifetime = min(lifeTimeStack[l], lifetime)
		if lifeTimeStack[l] < 0:
			lifeTimeStack.remove_at(l)
			dmgStack.remove_at(l)
			l -= 1

func _stack(entity : Effects) -> void:
	if(entity.effectName == effectName):
		print("Attempting to stack fire")
		lifeTimeStack.append(entity.lifetime)
		dmgStack = dmgStack + entity.dmgStack
	else:
		push_error("We fucked up somehow(FireStacks)")
