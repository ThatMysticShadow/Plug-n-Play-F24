extends Node
## This class is designed to be a singleton object for loading and reloading levels.
## The most important takeaway from this class is the reload level function which 
## reloads/restarts the level. This is called when you press "restart" in the pause menu
## and at the end of the default kill screen animation.
class_name LevelLoader

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Call this function to reload the scene
func reload_level() -> void:
	get_tree().paused = true
	animation_player.play("CLOSE")


## Method stub for me to implement later when stringing all the levels together
func load_level(level: PackedScene) -> void:
	get_tree().paused = true
	animation_player.play("CLOSE")


## This method is called when a level is ended
func end_level() -> void:
	get_tree().paused = true
	animation_player.play("CLOSE")


func _on_animation_finished(anim_name):
	if anim_name == "CLOSE":
		var _reload = get_tree().reload_current_scene()


func _on_scene_loaded():
	get_tree().paused = false
	animation_player.play("OPEN")
