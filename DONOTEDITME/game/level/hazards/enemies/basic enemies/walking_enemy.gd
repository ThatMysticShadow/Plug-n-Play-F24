extends EnemyBase
## A basic enemy that is legally distinct and modeled off of a certain type of
## enemy in a certain type of game
class_name WalkingEnemy

@export_category("Movement Config")
@export var horizontal_speed: float = 50
@export var max_fall_speed: float = 200
@export var gravity: float = 1000

@onready var ground_check: RayCast2D = $GroundBlockDetector
@onready var wall_check: RayCast2D = $WallDetector

var direction = 1

func _ready():
	super._ready()


func _physics_process(delta):
	velocity = Vector2(horizontal_speed * direction, 0)
	
	# Not a necessary optimization but only apply gravity if the player's fall speed is not at its maximum
	if velocity.y < max_fall_speed:
		velocity.y += delta * gravity
		
		# Clamp the player's velocity to this lower bound
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
			
	
	var ground_collider = ground_check.get_collider()
	if ground_collider == null || (ground_collider is Area2D and (ground_collider as Area2D).get_collision_layer_value(4)):
		print(ground_collider == null)
		change_direction()
	elif wall_check.get_collider() != null and is_on_floor():
		print("Whoa")
		var prob = randf()
		if prob < 0.5:
			change_direction()
		else:
			velocity.y = -30
	
	move_and_slide()

func change_direction():
	direction = -direction
	ground_check.rotation = abs(ground_check.rotation) * -direction
	wall_check.scale.x = abs(wall_check.scale.x) * direction
	wall_check.scale.y = abs(wall_check.scale.y) * direction
	
