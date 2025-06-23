extends Node2D

var myParent : Node2D
var timer : float = 0.0

func _process(delta: float) -> void:
	delta *= Global.getTimeScale()
	timer -= delta
	if(!is_instance_valid(myParent)):
		queue_free()
	else:
		global_position = myParent.global_position
	$Node2D.visible = timer >= 0.0

func get_over_health() -> Node2D:
	return $over

func get_actual_health() -> Node2D:
	return $actual

func get_animation_health() -> Node2D:
	return $animation

func get_animation_energy() -> Node2D:
	return $Node2D/animation_energy

func set_energy(energy : float) -> void:
	$Node2D/actual_energy.value = energy
	timer = 1

func update_maxMana(maxMana : float) -> void:
	$Node2D/animation_energy.max_value = maxMana
	$Node2D/actual_energy.max_value = maxMana
