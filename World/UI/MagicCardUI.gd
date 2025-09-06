extends ColorRect

signal pressed(card)

var c = null
var target = 0

@export var hover = false
@export var cardToShow : Resource

func _show(card):
	c = card
	var ca = card.color
	ca.a = 0.5
	$ColorRect.color = ca
	if((ca.r + ca.b + ca.g)/3.0 > 0.75):
		$VBoxContainer/Label.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label2.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label3.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label4.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label5.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label6.add_theme_color_override("font_color", Color.BLACK)
		$VBoxContainer/Label7.add_theme_color_override("font_color", Color.BLACK)
	$TextureRect.texture = card.icon
	$VBoxContainer/Label.text = card.cardName
	$VBoxContainer/Label3.text = card.cardDescription
	match(card.type):
		0:
			$VBoxContainer/Label2.text = "Element"
			if card.powerMult != 1:
				$VBoxContainer/Label4.visible = true
			$VBoxContainer/Label4.text = "Power Multiplier: " + str(card.powerMult)
			if card.castingSpeedMult != 1:
				$VBoxContainer/Label5.visible = true
			$VBoxContainer/Label5.text = "Cast Spd Multiplier: " + str(card.castingSpeedMult)
			if card.attackSpeedMult != 1:
				$VBoxContainer/Label6.visible = true
			$VBoxContainer/Label6.text = "Proj Spd Multiplier: " + str(card.attackSpeedMult)
			if card.sizeMult != 1:
				$VBoxContainer/Label7.visible = true
			$VBoxContainer/Label7.text = "Size Multiplier: " + str(card.sizeMult)
		1:
			$VBoxContainer/Label2.text = "Style"
			$VBoxContainer/Label4.visible = false
			$VBoxContainer/Label5.visible = false
			$VBoxContainer/Label6.visible = false
			$VBoxContainer/Label7.visible = false
		2:
			$VBoxContainer/Label2.text = "Type"
			$VBoxContainer/Label4.visible = false
			$VBoxContainer/Label5.visible = false
			$VBoxContainer/Label6.visible = false
			$VBoxContainer/Label7.visible = false

func _ready():
	if cardToShow != null:
		_show(cardToShow)

func _process(delta):
	if hover:
		position.y = lerpf(position.y, target, 0.1)

func _on_touch_screen_button_pressed():
	pressed.emit(c)

func _on_mouse_entered():
	target = -40

func _on_mouse_exited():
	target = 0
