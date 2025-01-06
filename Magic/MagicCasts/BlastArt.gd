extends Node2D

var time = 0

var scaled = false

func _process(delta):
	
	time += delta
	
	var num = get_children().size()
	if num <= 1:
		pass
	else:
		for i in range(num):
			get_children()[i].position.y = sin(time*10 - (2*PI*i)/num) * 300/num
			get_children()[i].z_index = (int)(cos(time*10 - (2*PI*i)/num) * 300/num + 100)
			
			print(get_children()[i].name + " zindex: " + str(get_children()[i].z_index))
			if !scaled:
				var scaleAmount = 1
				get_children()[i].scale = Vector2(get_children()[i].scale.x/(num * scaleAmount) * get_parent().mult, get_children()[i].scale.y/(num * scaleAmount) * get_parent().mult)
				get_children()[i].scale_amount_min = 0.05/(num * scaleAmount * 0.5) *get_parent().mult
				get_children()[i].scale_amount_max = 0.1/(num * scaleAmount * 0.5) *get_parent().mult
				
				print(str(get_children()[i].scale.x) + " scale")
		scaled = true
