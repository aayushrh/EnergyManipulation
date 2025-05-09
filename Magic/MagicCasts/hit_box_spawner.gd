extends Node
var rng = RandomNumberGenerator.new()
@onready var HitBox = preload("res://HitBoxParticle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(is_instance_valid(self)):
		if(get_parent().get_child(3) && get_parent().get_child(3).get_children().size() > 1):
			var hb = HitBox.instantiate()
			hb.dir = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized()*7
			add_child(hb)
		
