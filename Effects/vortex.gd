extends Node2D
class_name Vortex

var spell = null
var type = 0
var tickRate = 0.05

var bodiesIn = []
var rng = RandomNumberGenerator.new()

@onready var VortexEffect = preload("res://Effects/vortex_effect.tscn")

func _init() -> void:
	pass

#func _ready():
	#for i in range(rng.randi_range(10, 20)):
		#var randPos = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized() * rng.randf_range(0, 300)
		#var vortexE = VortexEffect.instantiate()
		#vortexE.parent = self
		#vortexE.global_position = global_position + randPos
		#get_tree().current_scene.add_child(vortexE)

func _setSpell(nspell, ntype):
	spell = nspell
	type = ntype
	
func _process(delta):
	delta *= Global.getTimeScale()
	#for i in range(rng.randi_range(0, 1)):
		#var randPos = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized() * rng.randf_range(300, 381)
		#var vortexE = VortexEffect.instantiate()
		#vortexE.parent = self
		#vortexE.global_position = global_position + randPos
		#get_tree().current_scene.add_child(vortexE)
	
	rotation_degrees += 180 * delta
	
	if spell != null and !Global.isPaused():
		var suctionPower = spell.getAttrScaled("Suction Power") * 50
		
		var hasV = false
		for i in bodiesIn:
			for j in i.get_children():
				if j is Vortex:
					hasV = true
			
			if i is Blast:
				i.v -= (i.global_position - global_position).normalized() * suctionPower
			else:
				if i is CharacterBody2D and !hasV:
					i.health -= spell.getPower() * spell.getAttrScaled("Suction Damage") * 2.5 * delta / max(pow(i.global_position.distance_to(global_position) / spell.getSize() * 10,0.25),0.5)
					if !i.slow:
						i.velocity -= (i.global_position - global_position).normalized() * suctionPower
					else:
						i.velocity -= 2 * (i.global_position - global_position).normalized() * suctionPower

func _on_area_2d_body_entered(body):
	if (body is Blast and is_instance_valid(body.sender) and body.sender.type != type) or (!(body is Blast) and is_instance_valid(body) and body.type != type and body != get_parent()):
		bodiesIn.append(body)

func _on_area_2d_body_exited(body):
	if (body is Blast and is_instance_valid(body.sender) and body.sender.type != type) or (!(body is Blast) and is_instance_valid(body) and body.type != type and body != get_parent()):
		bodiesIn.remove_at(bodiesIn.find(body))

"""func _on_timer_timeout():
	for i in bodiesIn:
		if !(i is Blast):
			print(i.health)
			i.health -= spell.getPower() * spell.getAttrScaled("Suction Damage") * 2.5 * tickRate / i.global_position.distance_squared_to(global_position)
			print(i.health)"""
