extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _update(hp):
	scale.x = 1 + 2*hp/100
	scale.y = 1 + 2*hp/100
