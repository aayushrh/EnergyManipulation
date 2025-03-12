extends Control

var effect : Effects

func initialize(effect):
	self.effect = effect
	$TextureProgressBar.max_value = effect.lifetime
	$Sprite2D.texture = effect.icon

func _process(delta):
	if(effect != null and effect.lifetime > 0):
		$TextureProgressBar.value = effect.lifetime
		if($TextureProgressBar.value > $TextureProgressBar.max_value):
			$TextureProgressBar.max_value = $TextureProgressBar.value
	else:
		queue_free()
