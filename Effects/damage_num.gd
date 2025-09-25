extends Node2D

var setAnimSpeed : float = 1
var currentNum : float = -1
var add := ""

func create(c, sc := Color(1,1,1,0.8), add := ""):
	$Label.set("theme_override_colors/font_color", c)
	var n = sc
	n.a = 0.8
	$Label/Label2.set("theme_override_colors/font_color", n)
	self.add = add


#non stacking
func _displayNum(num : float) -> void:
	var numb : float = abs(num)
	if num != 0:
		$Label.scale = $Label.scale * max(min(pow(len(add),0.25),2.5),1)
		$AnimationPlayer.play("UpandAwayDelay")
		$Label.text = str(round(num * 100)/10.0)
	else:
		$Label.text = ""
	$Label.text = $Label.text + add
	$Label/Label2.text = $Label.text

#stacking
func _display(num : float):
	$Label.scale = $Label.scale * max(min(pow(len(add),0.25),2.5),1)
	if num != 0:
		if currentNum != -1:
			$Label.text = str(round((currentNum + num) * 100)/10.0)
			currentNum += num
			$AnimationPlayer.stop()
			$AnimationPlayer.play("UpandAwayDelay")
		else:
			$Label.text = str(round(num * 100)/10.0)
			currentNum = num
		$Label.text = $Label.text + add
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
