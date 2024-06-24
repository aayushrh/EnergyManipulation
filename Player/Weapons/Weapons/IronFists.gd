extends Weapons

func _ready():
	fistLock = false

func _process(delta):
	$Left.global_position = leftArm.global_position
	$Right.global_position = rightArm.global_position
