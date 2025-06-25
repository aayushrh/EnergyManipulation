extends Node2D
class_name Vortex

var spell = null
var type = 0
var tickRate = 0.05
var timer = tickRate

var elements = []
var colorval = 0.0
var colorindex = 0
var colordelay = 0.0
var MAXCOLORDELAY = 0.1
var colorSpeed = 5.0

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
	elements = []
	if(spell.components):
		var n = 0
		for s in spell.components:
			if(s.isElement):
				elements.append(s);
	rotation_degrees -= 180 * delta
	color_change(delta)
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
					timer -= delta
					if(timer <= 0):
						i.health -= spell.getPower() * spell.getAttrScaled("Suction Damage") * 2.5 / max(pow(i.global_position.distance_to(global_position) / spell.getSize() * 10,0.5),0.5)/6
						timer = tickRate
					if !i.slow:
						i.velocity -= (i.global_position - global_position).normalized() * suctionPower
					else:
						i.velocity -= 2 * (i.global_position - global_position).normalized() * suctionPower

func color_change(delta):
	if elements.size() > 1:
		if(colordelay >= 0):
			colordelay -= delta
		else:
			var cv = colorindex - 1
			if(cv < 0):
				cv = elements.size() - 1
			if(colorval == 0):
				$"Vortex(2)".self_modulate = elements[cv].color
			else:
				$"Vortex(2)".self_modulate = elements[cv].color + (elements[colorindex].color-elements[cv].color) * colorval
			colorval += delta * 0.5 * colorSpeed
			if(colorval >= 1.0):
				colordelay = MAXCOLORDELAY
				colorval = 0
				colorindex = (colorindex + 1) % elements.size()
	elif elements.size() == 1:
		$"Vortex(2)".self_modulate = elements[0].color
	else:
		$"Vortex(2)".self_modulate = Color(0.4, 0.4, 0.4)
	$"Vortex(2)".self_modulate.a = 0.6
	

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
