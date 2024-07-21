extends Node2D

@export var rad = 10
@export var speed = 7

var time = 0
var state = 0

func _process(delta):
	if state == 0:
		time += delta * speed
		var x = rad * cos(-time)
		var y = rad * sin(-time)
		$Art/RArm.position.x = -x + 30 - time
		$Art/RArm.position.y = -y - 20 - time
		$Art/LArm.position.x = x - 30+ time
		$Art/LArm.position.y = -y - 20 - time
		var distV = $Art/RArm.position - Vector2(20 - time, -20 - time)
		var dist = pow(distV.x,2) + pow(distV.y,2)
		if(dist < 0.1 and time > 1):
			state += 1
			print(time)
	elif state == 1:
		$Art/RArm.position = Vector2(20 - time, -20 - time)
		$Art/LArm.position = Vector2(-20 + time, -20 - time)
		state += 1
	elif state == 2:
		$Art/RArm.position += Vector2(-0.25,-0.968) * 3
		$Art/LArm.position += Vector2(0.25,-0.968) * 3
		var distV = $Art/RArm.position - Vector2(5, -60)
		print(distV)
		var dist = pow(distV.x,2) + pow(distV.y,2)
		if(dist < 3):
			state += 1
	elif state == 3:
		$Art/RArm.position = Vector2(5, -60)
		$Art/LArm.position = Vector2(-5, -60)
		state += 1
