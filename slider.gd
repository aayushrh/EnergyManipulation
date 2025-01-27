extends Control

signal value_changed(lval: float, rval: float, bval: float, gradient: float, num: int)
signal nuhuh()
var num = 0
var attr = null
var n = 0

func _ready():
	$HSlider/Label.text = attr.attr.Ltext
	$HSlider/Label2.text = attr.attr.Rtext
	$HSlider.min_value = attr.attr.min
	n = attr.attr.num
	$HSlider.value = attr.rightvalue + attr.attr.min
	$HSlider.max_value = attr.attr.max
	$HSlider.step = attr.attr.step

func init(atr):
	attr = atr

func getNum():
	return $HSlider.value


func _on_h_slider_value_changed(value: float) -> void:
	var rightvalue = (value + 100)
	var leftvalue = (100 - value)
	var gradient = abs(value-(n))/($HSlider.max_value-n)
	value_changed.emit(leftvalue, rightvalue, n + 100, gradient, num)


func _on_h_slider_drag_started() -> void:
	nuhuh.emit()
