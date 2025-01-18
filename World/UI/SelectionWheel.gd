extends Control

@export var outer_radius : int
@export var inner_radius : int
@export var segments : int
@export var bkg_color : Color
@export var inside_color : Color
@export var selected_color : Color

var selectedNum = 0
var sprites = []

func _draw():
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_circle(Vector2.ZERO, inner_radius, inside_color)
	
	var mouse_pos = get_global_mouse_position()
	mouse_pos -= Vector2(1152/2, 648/2)
	var angleMouse = mouse_pos.angle_to_point(Vector2.ZERO)
	if(angleMouse < 0):
		angleMouse += 2*PI
	if(mouse_pos.y < 0):
		angleMouse += PI
	else:
		angleMouse -= PI
	for i in range(0, segments):
		var angle = (i*1.0)/(segments) * PI * 2
		draw_line(Vector2.ZERO, Vector2(cos(angle), sin(angle))*outer_radius, inside_color, 5)
		if angleMouse > angle && angleMouse < angle + 2*PI/segments :
			draw_arc(Vector2.ZERO, outer_radius, angle, angle + 2*PI/segments, 20, selected_color, 5)
			selectedNum = i

func _checkWeapons():
	var children = get_children()
	for i in children:
		i.queue_free()
	var j = 0
	for s in sprites:
		var sprite = s.instantiate()
		var angle = (j*1.0+0.5)/(segments) * PI * 2
		sprite.position = Vector2(cos(angle), sin(angle))*((outer_radius+inner_radius)/2.0) + Vector2(1152/2, 648/2)
		j += 1
		sprite.top_level = true
		add_child(sprite)

func _process(delta):
	queue_redraw()
