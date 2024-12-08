extends Area2D

@onready var player_reference: Player = $"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hitbox_entered(other: Area2D):
	if other is Energy && player_reference.current_health == 1:
		player_reference.add_shield()
		print_rich("[color=blue]energy")
