extends EnemyBase
## A basic enemy that is legally distinct and modeled off of a certain type of
## enemy in a certain type of game
class_name WalkingEnemy

@export_category("Movement Config")
@export var horizontal_speed: float = 50
@export var max_fall_speed: float = 200
@export var gravity: float = 1000

func _ready():
	super._ready()


func _physics_process(delta):
	velocity = Vector2(horizontal_speed, 0)
	
	# Not a necessary optimization but only apply gravity if the player's fall speed is not at its maximum
	if velocity.y < max_fall_speed:
		velocity.y += delta * gravity
		
		# Clamp the player's velocity to this lower bound
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	move_and_slide()
