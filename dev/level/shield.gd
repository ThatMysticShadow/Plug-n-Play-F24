extends Player

@export_category("Sound Config")

@export var player_hit_sound: AudioStream

@export var death_sound: AudioStream

@export var enemy_hit_sound: AudioStream

## Overwrites damage() and removes sound_player from get_source_damage() and moves it to check_death()
func damage(amount: float) -> void:
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

## The function is called when the player loses their shield (1 hp) and allows the player to 
## bounce off any non-enemy hazards
func shield_bounce() -> void:
	velocity.y = -jump_strength
	
