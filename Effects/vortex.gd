extends Node2D
class_name Vortex

var spell = null
var type = 0

var bodiesIn = []

func _setSpell(nspell, ntype):
	spell = nspell
	type = ntype
	
func _process(delta):
	if spell != null:
		var suctionPower = spell.getAttrScaled("Suction Power") * 50
		print("Suction power is: " + str(suctionPower))
		
		for i in bodiesIn:
			if i is Blast:
				i.v -= (i.global_position - global_position).normalized() * suctionPower * 5.0
			elif i is CharacterBody2D:
				i.velocity -= (i.global_position - global_position).normalized() * suctionPower

func _on_area_2d_body_entered(body):
	if (body is Blast and body.sender.type != type) or (!(body is Blast) and body.type != type and body != get_parent()):
		bodiesIn.append(body)

func _on_area_2d_body_exited(body):
	if (body is Blast and body.sender.type != type) or (!(body is Blast) and body.type != type and body != get_parent()):
		bodiesIn.remove_at(bodiesIn.find(body))

func _on_timer_timeout():
	for i in bodiesIn:
		if !(i is Blast):
			i.health -= spell.getPower() * spell.getAttrScaled("Suction Damage")
