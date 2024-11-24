extends RichTextLabel

func _ready():
	pass

func _on_meta_clicked(meta):
	Global._change_tscn(Global.lastTSCN)
