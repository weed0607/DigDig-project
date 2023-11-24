extends Node

var rng = RandomNumberGenerator.new()
var x_spd = rng.randf_range(0.1, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x += x_spd
	pass
