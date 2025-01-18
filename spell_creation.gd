extends Control
@export var cook: TypeSpellCard
@onready var page = preload("res://SpellPage.tscn")
func _ready():
	pass
	
func _input(event: InputEvent):
	if(event is InputEventMouseButton and event.pressed):
		var mp = get_global_mouse_position()
		if(mp.x >= Constants.SCREEN_SIZE.x/2 + 150 and mp.x <= Constants.SCREEN_SIZE.x/2 + 300):
			pass
		if(mp.x <= Constants.SCREEN_SIZE.x/2 - 150 and mp.x >= Constants.SCREEN_SIZE.x/2 - 300):
			pass
