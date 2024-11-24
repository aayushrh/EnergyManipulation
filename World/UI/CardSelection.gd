extends Control

signal finishedSelecting()

#var cardsToShow = [
	#SpellCard.new(0, "Fire", "Adds the Fire Element to you spell and inflicts *Burning* on the opponent"),
	#SpellCard.new(0, "Water", "Adds the Water Element to your spell and inflicts *Soggy* on your opponent"),
	#SpellCard.new(0, "Nature", "Adds the Nature element to your spell and inflicts *Life Steal* on your opponent"),
	#SpellCard.new(1, "Boar", "Adds the Boar style to your spell and inflicts *Stun* on your opponent"),
	#SpellCard.new(1, "Horse", "Adds the Horse style to your spell and reduces energy consumption"),
	#SpellCard.new(1, "Monkey", "Adds the Monkey style of your spell and adds piercing to your spells"),
	#SpellCard.new(2, "Blast", "Makes your spell type *Blast*"),
#]

@export var cardsToShow : Array[Resource]
@export var card1 : Control
@export var card2 : Control
@export var card3 : Control
@export var spawner : Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	card1.connect("pressed", onSelectedCard)
	card2.connect("pressed", onSelectedCard)
	card3.connect("pressed", onSelectedCard)
	spawner.connect("waveFinished", _show)

func _show():
	Global.pause = true
	visible = true
	var randCard = cardsToShow[rng.randi_range(0, cardsToShow.size() - 1)]
	card1._show(randCard)
	randCard = cardsToShow[rng.randi_range(0, cardsToShow.size() - 1)]
	card2._show(randCard)
	randCard = cardsToShow[rng.randi_range(0, cardsToShow.size() - 1)]
	card3._show(randCard)

func onSelectedCard(card):
	Global.magicCards.append(card)
	print(card)
	_hide()

func _hide():
	Global.pause = false
	visible = false
	finishedSelecting.emit()
