extends Node
## This class is designed to be a singleton object for loading and reloading levels.
## The most important takeaway from this class is the reload level function which 
## reloads/restarts the level. This is called when you press "restart" in the pause menu
## and at the end of the default kill screen animation.
class_name LevelLoader

const LEVEL_END_TIME: float = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var level_loaded: int = -1
var loading = false
var level_ended = false

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
	sound_player.unload_music_stream()
	level_loaded = -1
	level_ended = true


func _on_animation_finished(anim_name):
	if anim_name == "CLOSE" and not level_ended:
		var _reload = get_tree().reload_current_scene()


func _on_scene_loaded(level: Level):
	get_tree().paused = false
	animation_player.play("OPEN")
	
	if level_loaded != level.level_id:
		level_ended = false
		sound_player.load_music_stream(level.music_stream)
		level_loaded = level.level_id
