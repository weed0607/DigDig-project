extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var char = get_node("/root/Node2D/SubViewportContainer/SubViewport/LeftPlayer")
	self.position.x = char.position.x
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var char = get_node("/root/Node2D/SubViewportContainer/SubViewport/LeftPlayer")
	
	if !char.DEAD:
		self.position.y = char.position.y - 200
	
	pass
