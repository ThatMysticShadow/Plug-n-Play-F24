extends Control
## DO NOT TOUCH THIS CODE AT ALL. You should not need to modidy the pause screen.
class_name PauseMenu


@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var focus_button: Button = $MenuElements/ColorRect/VBoxContainer/ContinueButton

# Volume Sliders
@onready var master_slider: Slider = $MenuElements/ColorRect/VBoxContainer/MasterVolumeSlider/HSlider
@onready var sfx_slider: Slider = $MenuElements/ColorRect/VBoxContainer/SFXSlider/HSlider

var loaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(Control.FOCUS_ALL)
	sfx_slider.value = sfx_slider.max_value * sound_player.DEFAULT_SFX_VOL
	master_slider.value = master_slider.max_value * sound_player.DEFAULT_MASTER_VOL
	print(sound_player.master_curr_vol)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			anim_player.play("OPEN")
			get_tree().paused = true
		else:
			anim_player.play("CLOSE")


func get_sfx_volume():
	return sfx_slider.value / sfx_slider.max_value

func get_master_volume():
	return master_slider.value / master_slider.max_value


func _on_animation_finished(anim_name):
	if anim_name == "OPEN":
		focus_button.grab_focus()
	else:
		grab_focus()
		release_focus()
		get_tree().paused = false


func _on_sfx_slider_changed(value: float):
	sound_player.update_sound(self)
	
func _on_master_slider_changed(value: float):
	sound_player.update_sound(self)
