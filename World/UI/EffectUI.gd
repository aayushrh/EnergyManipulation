extends Control

var effect : Effects

func initialize(effect):
	self.effect = effect
	$TextureProgressBar.max_value = effect.lifetime
	$Sprite2D.texture = effect.icon

func _process(delta):
	if(effect != null and effect.lifetime > 0):
		if(effect.stackable):
			$stack.text = str(effect.stack)
		if(effect.lifetime > $TextureProgressBar.value + 0.01):
			$TextureProgressBar.max_value = effect.lifetime
		$TextureProgressBar.value = effect.lifetime
	else:
		queue_free()
