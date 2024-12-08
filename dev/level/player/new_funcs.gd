extends Player

@export_category("Sound Config")

@export var player_hit_sound: AudioStream

@export var death_sound: AudioStream

@export var enemy_hit_sound: AudioStream

@onready var anim_player2 = $sprite_animation

var isInv : bool = false

var hasShield = true

func _ready():
	current_health = starting_health
	footstep_time = footstep_max_time

## Overwrites damage() and removes sound_player from get_source_damage() and moves it to check_death()
func damage(amount: float) -> void:
	if(!isInv): 
		current_health -= amount
		current_health = clampf(current_health, 0, max_health)
		check_death()
	
## Overwrites get_source_damage() and removes sound_player from get_source_damage() and moves it to check_death()
func get_source_damage() -> float:
	sound_player.play_sound(enemy_hit_sound, global_position)
	return contact_damage

## Overwrites check_death() to also check if the player still has their shield (full 2 hp) and play
## distinct sounds for losing shield and dying
func check_death() -> void:
	if(current_health == 1.0):
		sound_player.play_sound(player_hit_sound, global_position)
		print_rich("[color=pink]Player has lost shield")
		shield_bounce()
	if current_health <= 0.0:
		sound_player.play_sound(death_sound, global_position)
		print_rich("[color=red]Player has died")
		level_loader.reload_level()

## Overwrites update_animation to also check if the player is falling and update the animation
func update_animation() -> void:
	if (!is_on_floor() && velocity.y < 0):
		anim_player2.play("jump")
	elif (velocity.y > 0):
		anim_player2.play("fall")
	else:
		if abs(velocity.x) < STOP_VELOCITY_THRSHOLD:
			anim_player2.play("idle")
		else:
			anim_player2.play("walk")
			
	sprite.flip_h = true if sign(velocity.x) < 0 else (false if sign(velocity.x) > 0  else sprite.flip_h)

## The function is called when the player loses their shield (1 hp) and allows the player to 
## bounce off any non-enemy hazards
func shield_bounce() -> void:
	velocity.y = -jump_strength
	#velocity.x = -(velocity.x-15) 
	%Shield.visible = false
	isInv = true
	hasShield = false
	%damage.start()

func _on_damage_timeout() -> void:
	isInv = false
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.3)

func _process(delta: float) -> void:
	if(isInv):
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "modulate", Color.RED, 0.2)

func add_shield() -> void:
	if(current_health == 1):
		current_health += 1
		%Shield.visible = true
		hasShield = true
