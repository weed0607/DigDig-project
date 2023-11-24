extends Node

var LAYER = "normal"
var HEALTH = 2
var EMPTY = preload("res://tex/mined bg.png")
var EMPTY_LAVA = preload("res://tex/lavalayerbrokenbg.png")

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
			if LAYER == "lava":
				sprite.texture = EMPTY_LAVA
			else:
				sprite.texture = EMPTY
			sprite.z_index = -1
		
	pass
