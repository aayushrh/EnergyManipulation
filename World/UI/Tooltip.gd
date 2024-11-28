extends Node2D

@export var orphan = false
var corner1 = Vector2.ZERO
var corner2 = Vector2.ZERO
var cooked = false
var wparents = false

func _ready():
	$ColorRect/Label.position = Vector2(7, 9)
	$ColorRect.size = $ColorRect/Label.size + Vector2(14, 18)
	$ColorRect3.size = $ColorRect/Label.size + Vector2(24, 28)
	$ColorRect2.visible = false

func _process(delta):
	print(corner1)
	if(!cooked):
		kysgodot()
		cooked = true
	if(!orphan):
		$ColorRect2.size = get_parent().size
	if(get_viewport().get_mouse_position().x > global_position.x and get_viewport().get_mouse_position().x < global_position.x + $ColorRect2.size.x and get_viewport().get_mouse_position().y > global_position.y and get_viewport().get_mouse_position().y < global_position.y + $ColorRect2.size.y):
		if(!wparents or get_viewport().get_mouse_position().x > corner1.x and get_viewport().get_mouse_position().x < corner2.x and get_viewport().get_mouse_position().y > corner1.y and get_viewport().get_mouse_position().y < corner2.y):
			_on_mouse_entered()
	else:
		_on_mouse_exited()
	$ColorRect.position = get_viewport().get_mouse_position() - global_position + Vector2(10 - (int(get_viewport().get_mouse_position().x > 576) * (20 + $ColorRect.size.x)), -(int(get_viewport().get_mouse_position().y>324) * (10 + $ColorRect.size.y)))
	$ColorRect3.position = $ColorRect.position + Vector2(-5, -5)

func _on_mouse_entered():
	$ColorRect.visible = true
	$ColorRect3.visible = true

func _on_mouse_exited():
	$ColorRect.visible = false
	$ColorRect3.visible = false

func kysgodot():
	if(orphan):
		wparents = false
		return null
	var gp = get_parent()
	while(true):
		gp = gp.get_parent()
		if(gp == null):
			wparents = false
			return null
		if(gp is ScrollContainer):
			break
	corner1 = gp.global_position
	corner2 = gp.global_position + gp.size
	wparents = true
