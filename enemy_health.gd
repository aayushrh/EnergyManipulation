extends Node2D

var myParent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!is_instance_valid(myParent)):
		queue_free()
	else:
		global_position = myParent.global_position

func get_over_health():
	return $over

func get_actual_health():
	return $actual

func get_animation_health():
	return $animation

func set_energy(energy):
	$actual_energy.value = energy
