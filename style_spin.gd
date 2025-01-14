extends CharacterBody2D

var perpV = 0.0# spd
var dist = 0.0 # dist
var num = 0 # waht number this one is(determines starting direction basically)
var amt = 1 # how many
var center = Vector2.ZERO
var tim = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tim += delta
	global_position = center + dist * Vector2.UP.rotated(float(num+tim)/float(amt) * 2 * PI)



func changeIcon(t):
	$TextureRect.texture = t

func changeColor(t):
	$TextureRect.self_modulate = t
