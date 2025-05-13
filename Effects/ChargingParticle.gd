extends Sprite2D

var v = Vector2.ZERO

func _ready():
	var rng = RandomNumberGenerator.new()
	scale.x = rng.randf_range(0.075, 0.1)
	scale.y = scale.x# * 3

func _process(delta):
	delta *= Global.getTimeScale()
	position += v * 1200 * delta
