extends Control


func _ready():
	var world = get_tree().current_scene
	$ColorRect2/ScrollContainer/VBoxContainer/Label17.text = "Spells Casted: " + str(world.spellsCasted)
	$ColorRect2/ScrollContainer/VBoxContainer/Label.text = "Amount Shot: " + str(world.amountShot)
	$ColorRect2/ScrollContainer/VBoxContainer/Label.visible = world.spellsCasted != world.amountShot
	$ColorRect2/ScrollContainer/VBoxContainer/Label2.text = "Spells Hit: " + str(world.amountHit)
	$ColorRect2/ScrollContainer/VBoxContainer/Label12.text = "Multi Hits: " + str(world.multiHits)
	$ColorRect2/ScrollContainer/VBoxContainer/Label12.visible = world.multiHits > 0
	$ColorRect2/ScrollContainer/VBoxContainer/Label16.visible = world.multiHits > 0
	$ColorRect2/ScrollContainer/VBoxContainer/Label16.text = "Total Hits: " + str(world.multiHits + world.amountHit)
	if(world.amountShot > 0):
		$ColorRect2/ScrollContainer/VBoxContainer/Label3.text = "Accuracy: " + roundString(float(world.amountHit)*100/(world.amountShot),0.1) + "%"
	$ColorRect2/ScrollContainer/VBoxContainer/Label3.visible = world.amountShot > 0
	$ColorRect2/ScrollContainer/VBoxContainer/Label13.text = "Damage Dealt: " + roundString(world.damageDealt,0.01)
	if(world.damageDealt > 0):
		$ColorRect2/ScrollContainer/VBoxContainer/Label14.text = "Average Damage per Hit: " + roundString(float(world.damageDealt)/(world.amountHit+world.multiHits),0.01)
		$ColorRect2/ScrollContainer/VBoxContainer/Label15.text = "Average Damage per Spell: " + roundString(float(world.damageDealt)/(world.spellsCasted),0.01)
	$ColorRect2/ScrollContainer/VBoxContainer/Label4.text = "Damage Taken: " + roundString(world.damageTaken,0.01)
	$ColorRect2/ScrollContainer/VBoxContainer/Label5.text = "Damage Blocked: " + roundString(world.damageBlocked,0.01)
	$ColorRect2/ScrollContainer/VBoxContainer/Label6.text = "Damage Healed: " + roundString(world.damageHealed,0.01)
	$ColorRect2/ScrollContainer/VBoxContainer/Label7.text = "Perfect Blocks: " + str(world.perfectBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label8.text = "Good Blocks: " + str(world.goodBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label9.text = "Bad Blocks: " + str(world.badBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label10.text = "No Blocks: " + str(world.noBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label11.text = "Enemies Killed: " + str(world.enemiesKilled)

func _show():
	_ready()

func roundString(a,b):
	return str(snapped(a,b))

func _process(delta):
	if(Input.is_action_just_pressed("Pause")):
		_on_exit_button_pressed()

func _on_exit_button_pressed():
	queue_free()
