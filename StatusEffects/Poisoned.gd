extends Effects
class_name Poisoned

var handledEffect : bool = false
var stack : int = 1
var timer := 0.0
var initTimer := 1.0
var mult := 2.0
var mt := 2.0

func _init(life : float, power : float) -> void:
	stackable = true
	lifetime = life * power * mult * mt
	visual = load("res://Effects/Poisoned.tscn")
	icon = load("res://Art/poison.png")
	effectName = "Poisoned"
	
func _tick(entity:Node2D, delta:float) -> void:
	if(floor(lifetime / mult) != stack):
		print("tick")
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "poison":
				stack = floor(lifetime / mult)
				i.stack = stack
	timer -= delta
	if(timer <= 0):
		take_dmg(entity)
	tick_lifeTime(delta)
	if lifetime <= 0:
		entity.effects.remove_at(entity.effects.find(self))
		for i : Node2D in entity.vfx:
			if i.vfxName.to_lower() == "poison":
				entity.vfx.remove_at(entity.vfx.find(i))
				i.queue_free()
				break
func take_dmg(entity:Node2D) -> void:
	entity.commit_dmg(-0.1, {"type": "poison", "color": Color(0.392, 0.784, 0.0, 1.0)})
	timer = max(initTimer / sqrt(stack), 1/30) if stack > 0 else 1

func tick_lifeTime(delta:float):
	lifetime -= delta * max(min(sqrt(stack), 30), 1)

func _stack(entity : Effects) -> void:
	if(entity.effectName == effectName):
		print("Attempting to stack poison")
		lifetime += entity.lifetime
	else:
		push_error("We fucked up somehow(PoisonStacks)")
