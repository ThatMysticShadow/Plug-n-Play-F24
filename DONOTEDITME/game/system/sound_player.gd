extends Node
## A singleton class designed for the playing of sounds. In any script you should be able to
## reference the sound_player object which provides you with a method to play a oneshot sound effect.
## DO NOT TOUCH THIS CODE AT ALL. You are also responsible for balancing audio to match the volume
## of the sample sound effects used.
class_name SoundPlayer

const DEFAULT_SFX_VOL: float = 0.2
const DEFAULT_MASTER_VOL: float = 1.0

@export_category("Settings Config")
@export var sfx_max_vol: float = 24
@export var sfx_min_vol: float = -10

@onready var sound_player = preload("res://DONOTEDITME/game/system/sound_effect.tscn")


var sfx_curr_vol = DEFAULT_SFX_VOL
var master_curr_vol = DEFAULT_MASTER_VOL

var sfx_list: Array[AudioStreamPlayer2D] = []


## Call this and provide an audio stream and a position for the sound to play a 
## one shot sound.
func play_sound(clip: AudioStream, position: Vector2):
	var player: AudioStreamPlayer2D = sound_player.instantiate()
	player.position = position
	player.stream = clip
	player.finished.connect(_on_effect_finished.bind(player))
	
	# Compute the sfx volume from the settings
	player.volume_db = compute_sfx_volume()
	
	sfx_list.append(player)
	get_tree().root.add_child(player)
	player.play()
	

## Making sure we queue free to clean up the queue of sounds
func _on_effect_finished(player: AudioStreamPlayer2D):
	sfx_list.remove_at(sfx_list.find(player))
	player.queue_free()

func compute_sfx_volume() -> float:
	if sfx_curr_vol == 0 || master_curr_vol == 0:
		return -20
	return (sfx_max_vol - sfx_min_vol) * sfx_curr_vol * master_curr_vol + sfx_min_vol

func update_sound(settings: PauseMenu):
	sfx_curr_vol = settings.get_sfx_volume()
	master_curr_vol = settings.get_master_volume()
	
	var sfx_computed_volume = compute_sfx_volume()
	for sfx in sfx_list:
		sfx.volume_db = sfx_computed_volume
