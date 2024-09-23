extends Button

@export var switching = ""

func _on_pressed():
	Global._change_tscn("res://World/" + switching + ".tscn")

func _on_meta_clicked(meta):
	Global._change_tscn("res://World/" + switching + ".tscn")
