extends Node

# ignore this pls
var HEALTH = 99
var IS_LAVA = true
var GAME_ENDED_AT = 0
var AUDIO

func kill(player):
	player.kill()
	
	var top_win = get_node("/root/Node2D/TopText")
	var bottom_win = get_node("/root/Node2D/BottomText")
	var other_player;
	
	if top_win.visible or bottom_win.visible:
		# someone has already won, don't show again
		return
	
	if player.name == "RightPlayer":
		other_player = get_node("/root/Node2D/SubViewportContainer/SubViewport/LeftPlayer")
		top_win.visible = true
	else:
		other_player = get_node("/root/Node2D/SubViewportContainer/SubViewport/RightPlayer")
		bottom_win.visible = true
		
	# Kill the other player too
	other_player.kill()
	
	GAME_ENDED_AT = Time.get_unix_time_from_system()
	AUDIO.play_victory()

# Called when the node enters the scene tree for the first time.
func _ready():
	AUDIO = get_node("/root/Node2D/SubViewportContainer/SubViewport/WorldAudio")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GAME_ENDED_AT != 0 and GAME_ENDED_AT + 3 <= Time.get_unix_time_from_system():
		# Restart
		get_tree().change_scene_to_file("res://node_2d.tscn")
	
	pass
