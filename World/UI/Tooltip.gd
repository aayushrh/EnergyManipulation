extends Node2D

@export var text : String

func _ready():
	$ColorRect/Label.set_text(text)
	var font = $ColorRect/Label.size
	print(font)
	$ColorRect.size = font
	$ColorRect2.visible = false
	print(text)

func _process(delta):
	if(get_viewport().get_mouse_position().x > global_position.x and get_viewport().get_mouse_position().x < global_position.x + $ColorRect2.size.x and get_viewport().get_mouse_position().y > global_position.y and get_viewport().get_mouse_position().y < global_position.y + $ColorRect2.size.y):
		_on_mouse_entered()
	else:
		_on_mouse_exited()
	$ColorRect.position = get_viewport().get_mouse_position() - global_position + Vector2(10, 0)

func _on_mouse_entered():
	$ColorRect.visible = true

func _on_mouse_exited():
	$ColorRect.visible = false
