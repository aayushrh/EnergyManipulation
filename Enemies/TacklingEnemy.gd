extends BaseEnemy
class_name TacklingEnemy

var cooldown : float = 3.0
var v : Vector2 = Vector2.ZERO
var dashing : bool = false
var dir : Vector2 = Vector2.ZERO
var timer : float = -1.0
var spell : Spell

@export var range : float = 200
@export var speed : float = 200
@export var time : float = 0.5
@export var damage : float = 10.0

func _ready():
	super._ready()
	$EnemyArt.finishReady.connect(_finish_ready)
	spell = Spell.new("goofy")

func _process(delta):
	cooldown -= delta * Global.timeScale
	
	if (dashing and timer > 0.0):
		timer -= delta * Global.timeScale
	if (dashing and timer <= 0.0):
		dashing = false
		overrideMove = false
		timer = -1.0
		print("finish tackle")
	
	if player != null and player.global_position.distance_to(global_position) <= range and cooldown <= 0 and !dashing:
		overrideMove = true
		$EnemyArt._play_ready()
		dir = (player.global_position - global_position).normalized()

func clone() -> TacklingEnemy:
	var tacklingEnemy := TacklingEnemy.new()
	tacklingEnemy.global_position = global_position
	tacklingEnemy.spell = spell
	return tacklingEnemy

func _finish_ready():
	dashing = true
	velocity = speed * dir * Global.timeScale
	timer = time
	print("start tackle")

func damageTaken():
	return damage

func _on_hitbox_body_entered(body):
	if is_instance_valid(body) and dashing:
		body._hit(self)
