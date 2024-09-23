extends Sprite2D

var v = Vector2.ZERO

func _ready():
	var rng = RandomNumberGenerator.new()
	scale.x = rng.randf_range(0.1, 0.2)
	scale.y = scale.x * 3

func _process(delta):
	position += v * 10
