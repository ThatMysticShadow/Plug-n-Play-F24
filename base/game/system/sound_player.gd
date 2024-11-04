extends Node
## A singleton class designed for the playing of sounds 
class_name SoundPlayer

@onready var sound_player = preload("res://base/game/system/sound_effect.tscn")

func play_sound(clip: AudioStream, position: Vector2):
	var player: AudioStreamPlayer2D = sound_player.instantiate()
	player.position = position
	player.stream = clip
	player.finished.connect(_on_effect_finished)
	

func _on_effect_finished(player: AudioStreamPlayer2D):
	player.queue_free()
