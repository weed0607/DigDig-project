extends AudioStreamPlayer2D

var HIT = preload("res://sfx/hit_block.wav")
var MOVE = preload("res://sfx/move_2.wav")
var TNT = preload("res://sfx/tnt_explode1.wav")
var VICTORY_ROYALE = preload("res://sfx/victory.wav")

func play_hit():
	self.stream = HIT
	self.play()
	
func play_move():
	self.stream = MOVE
	self.play()
	
func play_tnt():
	self.stream = TNT
	self.play()
	
func play_victory():
	self.stream = VICTORY_ROYALE
	self.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	autoplay = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
