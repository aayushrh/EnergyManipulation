extends Node2D

var sender : Node2D
var damage : int
var energy : float

var lifetime = 20

func _ready():
	scale.y = energy

func _on_hitbox_body_entered(body):
	if body != sender :
		body._hit(self)
	
func _process(delta):
	lifetime -= 1
	if lifetime <=0:
		queue_free()
