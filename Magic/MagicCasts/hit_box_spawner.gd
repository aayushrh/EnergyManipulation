extends Node
var rng := RandomNumberGenerator.new()
var timer : float = 1.0/120
@onready var HitBox := preload("res://HitBoxParticle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= Global.getTimeScale()
	timer -= delta
	if(timer<=0):
		if(is_instance_valid(self)):
			if(get_parent().get_child(3) && get_parent().get_child(3).get_children().size() > 1):
				var speed : float = min(get_parent().getSpeed()/100,1.5)
				var hb := HitBox.instantiate()
				hb.dir = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized()*7*speed
				hb.timer = 0.1/speed
				add_child(hb)
		timer = 1.0/120
