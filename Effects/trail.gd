extends Line2D

@export var trail_length : int
@export var parent : Node2D

func _process(delta):
	if is_instance_valid(parent):
		width = 75 * parent.scale.x
		if points.size() >= trail_length:
			#points.remove_at(0)
			remove_point(points.size() - 1)
		#points.append(parent.global_position)
		add_point(parent.global_position, 0)
		#print(str(points.size()))
	else:
		queue_free()
