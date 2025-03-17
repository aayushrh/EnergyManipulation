extends Node
class_name Effects

@export var lifetime = 10
@export var visual : PackedScene
@export var icon : CompressedTexture2D
@export var effectName : String
@export var stackable = false
@export var enemyShows = true

func _tick(entity, delta):
	pass
