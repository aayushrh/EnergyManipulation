extends BaseEnemy

var cooldown : float = 3.0
var v : Vector2 = Vector2.ZERO

@export var range : float = 200

func _process(delta):
	cooldown -= delta * Global.timeScale
	
	if player.global_position.distance_to(global_position) <= range and cooldown <= 0:
		overrideMove = true
		print("attacking")
