extends Control
	

func init2(attr):
	$Label.text = attr.attr.Ltext
	$Label2.text = attr.attr.Rtext
	$HSlider.min_value = attr.attr.min
	$HSlider.value = attr.num
	$HSlider.max_value = attr.attr.max
	$HSlider.step = attr.attr.step
	

func getNum():
	return $HSlider.value
