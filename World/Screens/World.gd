extends Node2D

func _ready():
	Global.magicCards = [SpellCard.new(0, "Fire"), SpellCard.new(0, "Fire"), SpellCard.new(1, "Dragon"), SpellCard.new(1, "Boar"), SpellCard.new(2, "Blast"), SpellCard.new(2, "Blast"), SpellCard.new(2, "Blast"), SpellCard.new(2, "Blast"), SpellCard.new(2, "Explosion"), SpellCard.new(0, "Water")]
	Global.spellList = []
	$CanvasLayer/ScrollContainer/SpellListUI.reload()

func _process(delta):
	#if Input.is_action_just_pressed("Pause") and !$CanvasLayer/Magic.visible:
		#Global.pause = !Global.pause
		#$CanvasLayer/InputChangeSystem.visible = !$CanvasLayer/InputChangeSystem.visible
		#$CanvasLayer/ScrollContainer.visible = !$CanvasLayer/ScrollContainer.visible
	#if Input.is_action_just_pressed("magicOpen") and !$CanvasLayer/Magic.dontLeave and !$CanvasLayer/InputChangeSystem.visible:
		#$CanvasLayer/ScrollContainer/SpellListUI.reload()
		#Global.pause = !Global.pause
		#$CanvasLayer/Magic.visible = !$CanvasLayer/Magic.visible
		#$CanvasLayer/ScrollContainer.visible = !$CanvasLayer/ScrollContainer.visible
	if Input.is_action_just_pressed("Pause") and !$CanvasLayer/MainMenu.visible:
		$CanvasLayer/MainMenu._show()
		Global.pause = true
		$CanvasLayer/ScrollContainer/SpellListUI.reload()
		print("true")

func _reloadSpellList():
	$CanvasLayer/ScrollContainer/SpellListUI.reload()
