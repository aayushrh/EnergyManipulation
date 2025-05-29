extends Node2D

var processed = false

func redy():
	for i in get_children().size():
		
		var num = get_children().size()
		print("this is i: " + str(i))
		var angle = (float(i))/(float(get_children().size())) * 2.0 * PI
		get_children()[i].position = Vector2(cos(angle), sin(angle)) * 100
		get_children()[i].scale = Vector2(0.5/get_children().size(), 0.5/get_children().size())
		if get_child(i) is CPUParticles2D:
			get_child(i).scale_amount_min = 0.15 * 1/num
			get_child(i).scale_amount_max = 0.3 * 1/num

func _process(delta):
	firstPhase(delta * Global.getTimeScale())

func firstPhase(delta):
	print("firstPhase")
	rotation_degrees += delta * 900 * get_parent().spell.getPSpeed()
	for i in get_children():
		i.position += 750 * delta * -i.position.normalized() * get_parent().spell.getPSpeed()
	
