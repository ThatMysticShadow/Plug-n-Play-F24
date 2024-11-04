extends Node2D
## Right now this is purely for transition purposes. DO NOT modify this class and your base node
## should be of type Level.
class_name Level

# Called when the node enters the scene tree for the first time.
func _ready():
	level_loader._on_scene_loaded()
