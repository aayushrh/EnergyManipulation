extends OptionButton

var textmomento = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("",0)
	add_item("New Spell",1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(textmomento and Input.is_action_just_pressed("enter")):
		get_parent().get_child(6).visible = false
		visible = true
		set_item_text(selected, get_parent().get_child(6).text)
		get_parent().get_child(6).text = ""


func _on_item_selected(index):
	if(index==item_count-1):
		get_parent().get_child(6).visible = true
		visible = false
		get_parent().get_child(6).grab_focus()
		add_item("New Spell",item_count)
		textmomento = true
	pass # Replace with function body.
