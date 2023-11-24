extends Node

var SCROLL_MAX = -1000
var SCROLL_MIN = 0
var SCROLL_SW = false
var SPD = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move right
	if !SCROLL_SW:
		if self.position.x <= SCROLL_MAX:
			SCROLL_SW = !SCROLL_SW
		
		self.position.x -= SPD
	else:
		if self.position.x >= SCROLL_MIN:
			SCROLL_SW = !SCROLL_SW
		
		self.position.x += SPD

	pass
