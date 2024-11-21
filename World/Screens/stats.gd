extends Control


func _ready():
	var world = get_tree().current_scene
	$ColorRect2/ScrollContainer/VBoxContainer/Label.text = "Amount Shot: " + str(world.amountShot)
	$ColorRect2/ScrollContainer/VBoxContainer/Label2.text = "Amount Hit: " + str(world.amountHit)
	if(world.amountShot > 0):
		$ColorRect2/ScrollContainer/VBoxContainer/Label3.text = "Accuracy: " + str(world.amountHit/world.amountShot)
	$ColorRect2/ScrollContainer/VBoxContainer/Label4.text = "Damage Taken: " + str(world.damageTaken)
	$ColorRect2/ScrollContainer/VBoxContainer/Label5.text = "Damage Blocked: " + str(world.damageBlocked)
	$ColorRect2/ScrollContainer/VBoxContainer/Label6.text = "Damage Healed: " + str(world.damageHealed)
	$ColorRect2/ScrollContainer/VBoxContainer/Label7.text = "Perfect Blocks: " + str(world.perfectBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label8.text = "Good Blocks: " + str(world.goodBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label9.text = "Bad Blocks: " + str(world.badBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label10.text = "No Blocks: " + str(world.noBlocks)
	$ColorRect2/ScrollContainer/VBoxContainer/Label11.text = "Enemies Killed: " + str(world.enemiesKilled)
	
func _process(delta):
	if(Input.is_action_just_pressed("Pause")):
		_on_exit_button_pressed()

func _on_exit_button_pressed():
	queue_free()
