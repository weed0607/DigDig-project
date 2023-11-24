extends Node

var HEALTH = 4
var EMPTY = preload("res://tex/mined bg.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HEALTH <= 0 && self.get_child_count() > 1:
		var collider = self.get_child(1)
		
		if collider != null:
			collider.queue_free()
		
		var sprite = self.get_child(0)
		
		if sprite != null:
			sprite.texture = EMPTY
			sprite.z_index = -1
		
	pass
