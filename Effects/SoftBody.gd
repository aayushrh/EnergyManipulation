extends Area2D

var bodiesInSpace= []

func getVector():
	var softBodyPush = Vector2.ZERO
	for i in bodiesInSpace:
		softBodyPush += global_position.direction_to(i.global_position) * 1/((global_position.distance_to(i.global_position))/50)
	return softBodyPush

func _on_body_entered(body):
	bodiesInSpace.append(body)

func _on_body_exited(body):
	bodiesInSpace.remove_at(bodiesInSpace.find(body))
