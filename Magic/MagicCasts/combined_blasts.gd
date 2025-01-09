extends Node2D

var time = 0.0

@onready var BlastProj = preload("res://Magic/MagicCasts/BlastProj.tscn")

var blasts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in blasts:
		initializeBlast(i)
	
func addBlast(blast):
	blasts.append(blast)

func initializeBlast(blast):
	var blastNew = BlastProj.instantiate()
	blastNew._setSpell(blast.spell)
	$Blasts.add_child(blastNew)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var num = get_children().size()
	
	var actualSize = 0;
	
	for i in range($Blasts.get_children().size()):
		actualSize += $Blasts.get_children()[i].scale.x
	
	for i in range($Blasts.get_children().size()):
		$Blasts.get_children()[i].position.y = sin(time*10 - (2*PI*i)/num) * (150 * actualSize * get_parent().spell.getSize())/(num*2)
		$Blasts.get_children()[i].z_index = (int)(cos(time*10 - (2*PI*i)/num) * 300/num + 200)
