extends Button

@export var maxtimer : float

var press = false
var timer = maxtimer

func _ready():
	timer = maxtimer

func _process(delta):
	if(timer<maxtimer):
		text = str(snapped(timer,.01)).pad_decimals(2)
		$ColorRect.size.x = (maxtimer-timer)/maxtimer*275
		$ColorRect.color = Color(1,0,0,(maxtimer-timer)/maxtimer) 
	if(press):
		timer-=delta
		if(timer<=0):
			get_tree().quit()
	else:
		if(timer<maxtimer):
			timer+=delta*2
		else:
			timer = maxtimer
			text = "EXIT"


func _on_button_up():
	press = false;



func _on_button_down():
	press = true;
