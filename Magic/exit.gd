extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(randi_range(1,50) == 1):
		text = "GTFO"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
