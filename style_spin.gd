extends CharacterBody2D

var perpV = 0.0
var dist = 0.0
var ccw = false
var num = 0 # waht number this one is(determines starting direction basically)
var amt = 1 # how many
var center = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():#rotation starts frum up now :p
	global_position = center + dist * Vector2.UP.rotated(float(num)/float(amt) * 2 * PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("ae")
	move(delta)
	move_and_slide()

func move(delta):
	velocity = ppv(center - global_position, ccw).normalized() * perpV * delta
	if(center.distance_to(global_position)>dist*1.1):
		if(center.distance_to(global_position)>dist*2):
			velocity += (center - global_position).normalized() * perpV * 2 * delta
		velocity += (center - global_position).normalized() * perpV * 0.1 * delta
	elif(center.distance_to(global_position)<dist*0.9):
		velocity -= (center - global_position).normalized() * perpV * 0.1 * delta
	#print(velocity.distance_to(Vector2.ZERO))

func ppv(vect, ccw):
	if(ccw):
		return Vector2(-vect.y,vect.x)
	else:
		return Vector2(vect.y,-vect.x)

func changeIcon(t):
	$TextureRect.texture = t

func changeColor(t):
	$TextureRect.self_modulate = t

func kill():
	#print("murder?")
	queue_free()
