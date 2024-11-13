extends Player

func damage(amount: float) -> void:
	sound_player.play_sound(hit_sound, global_position) # Assume when this is being called we are taking damage
	current_health -= amount
	current_health = clampf(current_health, 0, max_health)
	check_death()
	
func check_death() -> void:
	if(current_health <= 1.0):
		print_rich("[color=pink]Player has lost shield")
	if current_health <= 0.0:
		print_rich("[color=pink]Player has diedd")
		level_loader.reload_level()
