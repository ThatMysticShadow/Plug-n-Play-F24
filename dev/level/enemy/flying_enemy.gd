extends WalkingEnemy

func _ready():
	super._ready()
	anim_player.play("WALK")


func _physics_process(delta):
	velocity = Vector2(horizontal_speed * direction, velocity.y)
	
	# Not a necessary optimization but only apply gravity if the player's fall speed is not at its maximum
	if velocity.y < max_fall_speed:
		velocity.y += delta * gravity
		
		# Clamp the player's velocity to this lower bound
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	
	if wall_check.get_collider():
		var prob = randf()
		if prob < 0.5:
			change_direction()
		else:
			velocity.y = -jump_strength
	
	sprite.flip_h = false if sign(velocity.x) < 0 else (true if sign(velocity.x) > 0  else sprite.flip_h)
	move_and_slide()

## Called to flip the direction of the enemy and sprite
func change_direction():
	direction = -direction
	ground_check.rotation = abs(ground_check.rotation) * -direction
	wall_check.scale.x = abs(wall_check.scale.x) * direction
	wall_check.scale.y = abs(wall_check.scale.y) * direction
