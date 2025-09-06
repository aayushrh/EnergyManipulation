extends Node2D

@onready var Trail = preload("res://Effects/Trail.tscn")
@export var trailLength : int

func _ready():
	var trail = Trail.instantiate()
	trail.parent = self
	trail.trail_length = trailLength
	get_tree().current_scene.add_child(trail)

func _process(delta):
	scale = get_parent().scale
