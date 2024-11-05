extends Node
## A singleton class designed for the playing of sounds. In any script you should be able to
## reference the sound_player object which provides you with a method to play a oneshot sound effect.
## DO NOT TOUCH THIS CODE AT ALL. You are also responsible for balancing audio to match the volume
## of the sample sound effects used.
class_name SoundPlayer

const DEFAULT_SFX_VOL: float = 0.2
const DEFAULT_MASTER_VOL: float = 1.0
const DEFAULT_MUSIC_VOL: float = 0.5

@export_category("Settings Config")
@export var sfx_max_vol: float = 24
@export var sfx_min_vol: float = -10
@export var music_max_vol: float = 0
@export var music_min_vol: float = -20

@onready var sound_player = preload("res://DONOTEDITME/game/system/sound_effect.tscn")
@onready var music_player: AudioStreamPlayer = $SongPlayer

var sfx_curr_vol: float = 0.2
var master_curr_vol: float = 1.0
var music_curr_vol: float = 0.5

var sfx_list: Array[AudioStreamPlayer2D] = []
var music_fading = false

func _enter_tree():
	sfx_curr_vol = DEFAULT_SFX_VOL
	master_curr_vol = DEFAULT_MASTER_VOL
	music_curr_vol = DEFAULT_MUSIC_VOL

# Playing Sound Effects

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
	

## Making sure we queue free to clean up the queue of sounds. EVENT HANDLER DO NOT CALL
func _on_effect_finished(player: AudioStreamPlayer2D):
	sfx_list.remove_at(sfx_list.find(player))
	player.queue_free()


## NO NEED TO CALL THIS METHOD
func compute_sfx_volume() -> float:
	if sfx_curr_vol == 0 || master_curr_vol == 0:
		return -20
	return (sfx_max_vol - sfx_min_vol) * sfx_curr_vol * master_curr_vol + sfx_min_vol

## NO NEED TO CALL THIS METHOD
func compute_music_volume() -> float:
	if music_curr_vol == 0 || master_curr_vol == 0:
		return -40
	return (music_max_vol - music_min_vol) * music_curr_vol * master_curr_vol + music_min_vol


## NO NEED TO CALL THIS METHOD. This is just to update the sound values when the pause menu is modified
func update_sound(settings: PauseMenu):
	sfx_curr_vol = settings.get_sfx_volume()
	master_curr_vol = settings.get_master_volume()
	music_curr_vol = settings.get_music_volume()
	
	var sfx_computed_volume = compute_sfx_volume()
	for sfx in sfx_list:
		sfx.volume_db = sfx_computed_volume
		
	music_player.volume_db = compute_music_volume()

# Playing Songs

##  When a level is loaded this is called. DO NOT CALL THIS
func load_music_stream(song: AudioStream) -> void:
	music_fading = false
	music_player.volume_db = compute_music_volume()
	music_player.stream = song
	music_player.play()


## When a level ends the song should fade out. DO NOT CALL THIS
func unload_music_stream() -> void:
	music_fading = true
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(music_player, "volume_db", -40, level_loader.LEVEL_END_TIME)
