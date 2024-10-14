extends Node2D

var sender : Node2D
var energy : float

var lifetime = 20

func _ready():
	$Node2D.scale.y = energy

func _on_hitbox_body_entered(body):
	if body != sender :
		body._hit(self)

func damageTaken(reciever):
	var damage = energy
	print(damage * (256 - reciever.global_position.distance_to(sender.global_position))/256)
	return damage * (256 - reciever.global_position.distance_to(sender.global_position))/256
	
func _process(delta):
	lifetime -= 1
	if lifetime <=0:
		queue_free()
