extends Node2D

@export var orphan = false

func _ready():
	$ColorRect/Label.position += Vector2(7, 9)
	$ColorRect.size = $ColorRect/Label.size + Vector2(14, 18)
	$ColorRect3.size = $ColorRect/Label.size + Vector2(24, 28)
	$ColorRect2.visible = false

func _process(delta):
	if(!orphan):
		$ColorRect2.size = get_parent().size
	if(get_viewport().get_mouse_position().x > global_position.x and get_viewport().get_mouse_position().x < global_position.x + $ColorRect2.size.x and get_viewport().get_mouse_position().y > global_position.y and get_viewport().get_mouse_position().y < global_position.y + $ColorRect2.size.y):
		_on_mouse_entered()
	else:
		_on_mouse_exited()
	$ColorRect.position = get_viewport().get_mouse_position() - global_position + Vector2(10 - (int(get_viewport().get_mouse_position().x > 576) * (20 + $ColorRect.size.x)), 0)
	$ColorRect3.position = $ColorRect.position + Vector2(-5, -5)

func _on_mouse_entered():
	$ColorRect.visible = true
	$ColorRect3.visible = true

func _on_mouse_exited():
	$ColorRect.visible = false
	$ColorRect3.visible = false
