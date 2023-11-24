extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)
	
func _button_pressed():
	# Load the main scene
	get_tree().change_scene_to_file("res://node_2d.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
