extends Node2D

func _displayNum(num : float, player : bool) -> void:
	if num > 0:
		$Label.text = str(ceil(num * 10))
		$AnimationPlayer.speed_scale = min((0.25)/num, 2)
		$Label.set("theme_override_colors/font_color", Color(0, 1, 0))
		$Label.scale = Vector2(min(max(num, 0.25), 0.75), min(max(num, 0.25), 0.75))
	elif num < 0:
		if -num >= 0.1:
			$Label.text = str(ceil(-num * 10))
		else:
			$Label.text = str(ceil((-num * 100.0))/10.0)
		$AnimationPlayer.speed_scale = min((0.25)/-num, 2)
		if player:
			$Label.set("theme_override_colors/font_color", Color(1, 0, 0))
		else:
			$Label.set("theme_override_colors/font_color", Color(1, 1, 1))
		$Label.scale = Vector2(min(max(-num, 0.4), 0.75), min(max(-num, 0.4), 0.75))
	else:
		$Label.text = ""

func _ready():
	$AnimationPlayer.play("InandOut")

func _on_animation_player_animation_finished(anim_name):
	queue_free()
