extends Node2D

var setAnimSpeed : float = 1

func _displayNum(num : float, player : bool) -> void:
	var numb : float = num
	if num != 0:
		if num > 0:
			$Label.set("theme_override_colors/font_color", Color(0, 1, 0))
			$Label.scale = Vector2(min(max(num, 0.25), 0.75), min(max(num, 0.25), 0.75))
		else:
			numb = -num
			if player:
				$Label.set("theme_override_colors/font_color", Color(1, 0, 0))
			else:
				$Label.set("theme_override_colors/font_color", Color(1, 1, 1))
			$Label.scale = Vector2(min(max(-num, 0.4), 0.75), min(max(-num, 0.4), 0.75))
		$AnimationPlayer.speed_scale = min(max((0.25)/numb,0.05), 2)
		if numb >= 0.1:
			$Label.text = str(ceil(numb * 10))
		else:
			$Label.text = str(ceil((numb * 100.0))/10.0)
	else:
		$Label.text = ""

func _ready() -> void:
	$AnimationPlayer.play("InandOut")
	
func _process(delta: float) -> void:
	delta *= Global.getTimeScale()
	setAnimSpeed = delta * 120
	$AnimationPlayer.speed_scale = setAnimSpeed

func _on_animation_player_animation_finished(anim_name:String) -> void:
	queue_free()
