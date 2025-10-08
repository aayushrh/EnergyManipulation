extends Control

signal value_changed(val: float, num: int)
signal nuhuh()
var num = 0
var attr = null

func _ready():
	$HSlider/Label.text = attr.Rtext
	$HSlider/Label2.text = attr.Ltext
	$HSlider.min_value = attr.min
	$HSlider.value = attr.value
	$HSlider.max_value = attr.max
	$HSlider.step = attr.step

func init(atr, number):
	attr = atr
	num = number

func getNum():
	return $HSlider.value

func _on_h_slider_value_changed(value: float) -> void:
	value_changed.emit(value, num)


func _on_h_slider_drag_started() -> void:
	nuhuh.emit()
