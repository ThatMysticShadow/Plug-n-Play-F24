extends Node
## This class is designed to be a singleton object for loading and reloading levels.
## The most important takeaway from this class is the reload level function which 
## reloads/restarts the level. This is called when you press "restart" in the pause menu
## and at the end of the default kill screen animation.
class_name LevelLoader

## Call this function to reload the scene
func reload_level() -> void:
	var _reload = get_tree().reload_current_scene()


## Method stub for me to implement later when stringing all the levels together
func load_level(level: PackedScene) -> void:
	pass
