extends Node2D

var time = 0

var scaled = false
var processed = false

func _process(delta):
	time += delta
	
	if processed:
		var num = get_children().size()
		if num <= 1:
			pass
		else:
			for i in range(num):
				get_children()[i].position.y = sin(time*10 - (2*PI*i)/num) * (150 * 0.5)/(num)
				get_children()[i].z_index = (int)(cos(time*10 - (2*PI*i)/num) * 300/num + 200)
				
				print(get_children()[i].name + " zindex: " + str(get_children()[i].z_index))
				if !scaled:
					get_children()[i].scale = Vector2(1.0001/(num * 1.5), 1.0001/(num * 1.5))
					get_children()[i].scale_amount_min = 0.1 * get_parent().scale.x/(num)
					get_children()[i].scale_amount_max = 0.2 * get_parent().scale.x/(num)
			scaled = true
