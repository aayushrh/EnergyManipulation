extends Sprite2D

var v = Vector2.ZERO
var timescale = 2.0

func _ready():
	var rng = RandomNumberGenerator.new()
	scale.x = rng.randf_range(0.001, 0.01)
	scale.y = scale.x * rng.randf_range(1,10)
	self_modulate.a = 0

func _process(delta):
	delta *= Global.getTimeScale() * timescale
	position += v * 100 * delta
	scale.y *= pow(5,delta*5)
	scale.x /= pow(5,delta*5)
	self_modulate.a+=delta*100
