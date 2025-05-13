extends Node2D

var time = 0

var scaled = false
var processed = false



func _process(delta):
	delta *= Global.getTimeScale()
	time += delta
	
	if processed:
		var num = get_children().size() + 0.0
		if num <= 1:
			pass
		else:
			for i in range(num):
				get_child(i).position.y = sin(time*10 - (2*PI*i)/num) * ((150 * 0.5) - (75 * 0.5/num))#*(num/5)
				get_child(i).position.x = cos(time*10 - (2*PI*i)/num) * -((150 * 0.25) - (75 * 0.5/num))#*(num/5)
				get_child(i).z_index = (int)(cos(time*10 - (2*PI*i)/num) * 300/num + 200)
				
				if !scaled and get_child(i) is CPUParticles2D:
					get_child(i).scale = Vector2(0.75/num, 0.75/num)
					get_child(i).scale_amount_min = 0.075 * 1/num
					get_child(i).scale_amount_max = 0.15 * 1/num
			scaled = true
			
