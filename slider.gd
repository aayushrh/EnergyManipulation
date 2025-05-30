extends Control

signal value_changed(lval: float, rval: float, num: int)
signal nuhuh()
var num = 0
var attr = null
var n = 0

func _ready():
	$HSlider/Label.text = attr.attr.Rtext
	$HSlider/Label2.text = attr.attr.Ltext
	$HSlider.min_value = attr.attr.minL
	n = attr.attr.num
	$HSlider.value = attr.leftvalue
	$HSlider.max_value = attr.attr.maxL
	$HSlider.step = attr.attr.step

func init(atr):
	attr = atr

func getNum():
	return $HSlider.value

func _on_h_slider_value_changed(value: float) -> void:
	var ratio = (value - attr.attr.minL)/(attr.attr.maxL-attr.attr.minL)
	var rightvalue = attr.attr.minR + ((1.0-ratio) * (attr.attr.maxR - attr.attr.minR))
	var leftvalue = value
	value_changed.emit(leftvalue, rightvalue, num)


func _on_h_slider_drag_started() -> void:
	nuhuh.emit()
