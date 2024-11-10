extends Control

signal finishedSelecting()

var cardsToShow = [
	SpellCard.new(0, "Fire"),
	SpellCard.new(0, "Water"),
	SpellCard.new(0, "Nature"),
	SpellCard.new(1, "Boar"),
	SpellCard.new(1, "Horse"),
	SpellCard.new(1, "Monkey"),
	SpellCard.new(2, "Blast"),
]

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
	_hide()

func _hide():
	Global.pause = false
	visible = false
	finishedSelecting.emit()
