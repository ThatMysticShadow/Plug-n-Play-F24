extends Node
## A singleton class designed for the playing of sounds. In any script you should be able to
## reference the sound_player object which provides you with a method to play a oneshot sound effect
class_name SoundPlayer

@onready var sound_player = preload("res://DONOTEDITME/game/system/sound_effect.tscn")

## Call this and provide an audio stream and a position for the sound to play a 
## one shot sound.
func play_sound(clip: AudioStream, position: Vector2):
	var player: AudioStreamPlayer2D = sound_player.instantiate()
	player.position = position
	player.stream = clip
	player.finished.connect(_on_effect_finished.bind(player))

	get_tree().root.add_child(player)
	player.play()
	

## Making sure we queue free to clean up the queue of sounds
func _on_effect_finished(player: AudioStreamPlayer2D):
	player.queue_free()
