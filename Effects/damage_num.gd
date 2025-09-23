extends Node2D

var setAnimSpeed : float = 1
var currentNum : float = -1

func create(c, sc := Color(1,1,1,0.8)):
	$Label.set("theme_override_colors/font_color", c)
	var n = sc
	n.a = 0.8
	$Label/Label2.set("theme_override_colors/font_color", n)


#non stacking
func _displayNum(num : float) -> void:
	var numb : float = abs(num)
	if num != 0:
		$Label.scale = Vector2(min(max(num, 0.25), 0.75), min(max(num, 0.25), 0.75))
		$AnimationPlayer.speed_scale = min(max((0.25)/numb,0.05), 2)
		if numb >= 0.1:
			$Label.text = str(ceil(numb * 10))
		else:
			$Label.text = str(ceil((numb * 100.0))/10.0)
	else:
		$Label.text = ""
	$Label/Label2.text = $Label.text

#stacking
func _display(num : float):
	print("ASSDF" + str(num))
	if num != 0:
		if currentNum != -1:
			$Label.text = str(round((currentNum + num) * 100)/10.0)
			currentNum += num
			$AnimationPlayer.stop()
			$AnimationPlayer.play("UpandAwayDelay")
		else:
			$Label.text = str(round(num * 100)/10.0)
			currentNum = num
	else:
		$Label.text = ''
	$Label/Label2.text = $Label.text

func _disappear():
	print("numero: " + str(currentNum))
	queue_free()

func _ready() -> void:
	$AnimationPlayer.play("UpandAway")
	
func _process(delta: float) -> void:
	delta *= Global.getTimeScale()
	setAnimSpeed = delta * 120
	$AnimationPlayer.speed_scale = setAnimSpeed

func _on_animation_player_animation_finished(anim_name:String) -> void:
	print("num: " + str(currentNum))
	queue_free()
