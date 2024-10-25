extends EnemyBase
## A basic enemy that is legally distinct and modeled off of a certain type of
## enemy in a certain type of game
class_name WalkingEnemy

@export_category("Movement Config")
@export var horizontal_speed: float = 50

func _ready():
	super._ready()


func _physics_process(delta):
	velocity = Vector2(horizontal_speed, 0)
	move_and_slide()
