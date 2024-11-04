extends Control


@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var focus_button: Button = $MenuElements/ColorRect/VBoxContainer/ContinueButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:
			anim_player.play("OPEN")
			get_tree().paused = true
		else:
			anim_player.play("CLOSE")


func _on_animation_finished(anim_name):
	if anim_name == "OPEN":
		focus_button.grab_focus()
	else:
		grab_focus()
		release_focus()
		get_tree().paused = false
