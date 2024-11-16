extends Player

## Overwrites check_death() to also check if the player still 
## has their shield (full health)
func check_death() -> void:
	if(current_health == 1.0):
		print_rich("[color=pink]Player has lost shield")
		shield_damage()
	if current_health <= 0.0:
		print_rich("[color=red]Player has died")
		level_loader.reload_level()

## shield_damage is called when current_health = 1 and allows 
## the player to bounce off any 
func shield_damage() -> void:
	velocity.y = -jump_strength	+5
