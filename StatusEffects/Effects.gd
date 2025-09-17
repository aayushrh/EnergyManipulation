extends Node
class_name Effects

@export var lifetime : float = 10
@export var visual : PackedScene
@export var icon : CompressedTexture2D
@export var effectName : String
@export var stackable : bool = false
@export var enemyShows : bool = true

func _tick(entity : Node2D, delta : float) -> void:
	pass

func _stack(entity : Effects) -> void:
	pass
