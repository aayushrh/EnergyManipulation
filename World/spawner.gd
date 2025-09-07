extends Node2D

signal waveFinished

var rng = RandomNumberGenerator.new()

@onready var BasicEnemy = preload("res://Enemies/BasicEnemy.tscn")

@export var enemyParent : Node2D
@export var player : Node2D
@export var cardSelection : Control

var waveNumber = 1;
var spawned = 0;
var readyToSpawn = false
var emitted = false

func _ready():
	cardSelection.connect("finishedSelecting", _startNextWave)

func _process(delta):
	if(!Global.isPaused()):
		rng.randomize()
		var spawn = rng.randi_range(0, 250)
		if(spawn < 1 and spawned < min(ceil(0.2 * waveNumber), 2)):
			var num = rng.randi_range(0, 3)
			var spawnLoc = Vector2.ZERO
			if(num == 0):
				spawnLoc = Vector2(rng.randf_range(-1400, 1400), 950)
			if(num == 1):
				spawnLoc = Vector2(rng.randf_range(-1400, 1400), -950)
			if(num == 2):
				spawnLoc = Vector2(1400, rng.randf_range(-950, 950))
			if(num == 3):
				spawnLoc = Vector2(-1400, rng.randf_range(-950, 950))
			
			var basicEnemy = BasicEnemy.instantiate()
			basicEnemy.global_position = spawnLoc# + player.global_position
			basicEnemy.agg = randi_range(0,1)==1
			#basicEnemy.health = max(1, waveNumber/2)
			basicEnemy.stage = waveNumber
			enemyParent.add_child(basicEnemy)
			spawned += 1
		
		if enemyParent.get_children().size() <= 0 and spawned >= min(ceil(0.2 * waveNumber), 2):
			readyToSpawn = true
			if !emitted:
				waveFinished.emit()
				emitted = true

func _startNextWave():
	if readyToSpawn:
		spawned = 0
		waveNumber += 1
		emitted = false
