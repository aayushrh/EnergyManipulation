extends Node2D
class_name HitBoxParticle

var dir: Vector2
var timer = 0.1
var timer2 = 1
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale *= 0.1
	closest_colors()
	$TrueWhiteCircle.self_modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	closest_colors()
	timer -= delta
	if(timer <= 0):
		timer2 -= delta
		circle()
		$TrueWhiteCircle.self_modulate.a += delta*0.5
		if(timer2 <= 0):
			queue_free()
	else:
		self.position+=dir
	

func circle():
	position = position.rotated(PI*0.1)
	
	

func closest_colors():
	var e = get_parent().get_parent().get_child(3).get_children()
	var smd = -1
	var smd2 = -1
	var col: Color
	var col2: Color
	for i in e:
		if(i.is_class("CPUParticles2D")):
			var temp = i.position.distance_squared_to(position)
			if(smd<0 || temp < smd):
				
				if(col):
					col2 = col
					smd2 = smd
				smd = temp
				col = i.color_ramp.get_color(0.0)
			elif(smd2<0 || temp < smd2):
				smd2 = temp
				col2 = i.color_ramp.get_color(0.0)
	var finalCol: Color
	if(col || col2):
		if(col && col2):
			finalCol = Color((col.r*smd2 + col2.r*smd)/(smd+smd2),(col.g*smd2 + col2.g*smd)/(smd+smd2),(col.b*smd2 + col2.b*smd)/(smd+smd2))
		elif(col):
			finalCol = col
		else:
			finalCol = col2
		$TrueWhiteCircle.self_modulate.r = finalCol.r
		$TrueWhiteCircle.self_modulate.g = finalCol.g
		$TrueWhiteCircle.self_modulate.b = finalCol.b
