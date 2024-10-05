extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Pause") and !$CanvasLayer/Magic.visible:
		Global.pause = !Global.pause
		$CanvasLayer/InputChangeSystem.visible = !$CanvasLayer/InputChangeSystem.visible
		$CanvasLayer/ScrollContainer.visible = !$CanvasLayer/ScrollContainer.visible
	if Input.is_action_just_pressed("magicOpen") and !$CanvasLayer/Magic.dontLeave and !$CanvasLayer/InputChangeSystem.visible:
		$CanvasLayer/ScrollContainer/SpellListUI.reload()
		Global.pause = !Global.pause
		$CanvasLayer/Magic.visible = !$CanvasLayer/Magic.visible
		$CanvasLayer/ScrollContainer.visible = !$CanvasLayer/ScrollContainer.visible
