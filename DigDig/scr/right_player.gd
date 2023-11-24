extends Node

const JUMP_FORCE = 350
const DIG_COOLDOWN = 100

var rng = RandomNumberGenerator.new()

var SIDE_MAX = 6
var SIDE_CUR = 0

var LAST_DIG = Time.get_unix_time_from_system()
var ANIM = "default"
var DIGGING = false
var DIGGING_RIGHT = false
var DIGGING_LEFT = false
var RAYCAST = null
var LAST_MOVED_SIDE = Time.get_unix_time_from_system()

var SCORE = 0
var INIT_Y = self.position.y
var DEAD = false
var DID_ANIM = false

var PARTICLES
var AUDIO

func kill():
	self.lock_rotation = false
	self.get_child(0).disabled = true 
	
	DEAD = true

# Called when the node enters the scene tree for the first time.
func _ready():
	PARTICLES = get_child(1).get_child(0)
	AUDIO = get_child(-1)
	pass # Replace with function body.

func _integrate_forces(s):
	var cur_time = Time.get_unix_time_from_system()
	var sprite = get_node("RightSprite")
	var right_cast_high = get_node("RightCastHigh")
	var right_cast_low = get_node("RightCastLow")
	var left_cast_high = get_node("LeftCastHigh")
	var left_cast_low = get_node("LeftCastLow")
	var lv = s.get_linear_velocity()
	var t = s.get_transform()
		
	if DEAD:
		if !DID_ANIM:
			lv.y = -350
			lv.x = rng.randi_range(200, -200)
			
			s.set_linear_velocity(lv)
			s.set_angular_velocity(8 if lv.x > 0 else -8)
			
			DID_ANIM = true
		return
	
	# Left/right controlling
	if cur_time >= LAST_MOVED_SIDE + 0.2:
		if !right_cast_high.is_colliding() and !right_cast_low.is_colliding()  and Input.is_action_pressed("move_right_1", true) and SIDE_CUR < SIDE_MAX:
			AUDIO.play_move()
			
			t.origin.x += 32
			s.set_transform(t)
			sprite.set_flip_h(false)
			
			LAST_MOVED_SIDE = cur_time
			SIDE_CUR += 1

		if !left_cast_high.is_colliding() and !left_cast_low.is_colliding()  and Input.is_action_pressed("move_left_1", true) and SIDE_CUR > -SIDE_MAX:
			AUDIO.play_move()
			
			t.origin.x -= 32
			s.set_transform(t)
			sprite.set_flip_h(true)
			
			LAST_MOVED_SIDE = cur_time
			SIDE_CUR -= 1
	
	if lv.y == 0 and Input.is_action_pressed("move_up_1", true):
		lv.y -= 350
		
	if lv.y != 0 and Input.is_action_pressed("move_down_1", true):
		# Activate drilling mode
		ANIM = "digging"
		DIGGING = true
		
	if !Input.is_action_pressed("move_down_1", true):
		ANIM = "default"
		DIGGING = false
		
	if DIGGING:
		var raycast = get_node("FloorCast")
		
		if cur_time >= LAST_DIG + 0.2 and raycast.is_colliding():
			AUDIO.play_hit()
			
			var block = raycast.get_collider()
			var part_tex = AtlasTexture.new()
			
			part_tex.atlas = block.get_child(0).texture
			part_tex.filter_clip = true
			part_tex.region = Rect2(Vector2(0, 0), Vector2(8, 8))
			
			PARTICLES.texture = part_tex
			PARTICLES.emitting = true
			LAST_DIG = cur_time
			
			lv.y = -150
			
			block.HEALTH -= 1
	else:
		PARTICLES.emitting = false
			
	# Side digging
	if !DIGGING and (right_cast_high.is_colliding() or right_cast_low.is_colliding()) and Input.is_action_pressed("move_right_1", true):
		# Set anim
		ANIM = "dig_side"
		sprite.set_flip_h(false)
		
		var high_cast = right_cast_high
		var low_cast = right_cast_low
		var did_dig = false
		
		if cur_time >= LAST_DIG + 0.2 and high_cast.is_colliding():
			var block = high_cast.get_collider()
			
			block.HEALTH -= 1
			did_dig = true
			
		if cur_time >= LAST_DIG + 0.2 and low_cast.is_colliding():
			var block = low_cast.get_collider()
			
			block.HEALTH -= 1
			did_dig = true
			
		if did_dig:
			AUDIO.play_hit()
			LAST_DIG = cur_time
		
	if !DIGGING and (left_cast_high.is_colliding() or left_cast_low.is_colliding()) and Input.is_action_pressed("move_left_1", true):
		# Set anim
		ANIM = "dig_side"
		sprite.set_flip_h(true)
		
		var high_cast = left_cast_high
		var low_cast = left_cast_low
		var did_dig = false
		
		if cur_time >= LAST_DIG + 0.2 and high_cast.is_colliding():
			var block = high_cast.get_collider()
			
			block.HEALTH -= 1
			did_dig = true
			
		if cur_time >= LAST_DIG + 0.2 and low_cast.is_colliding():
			var block = low_cast.get_collider()
			
			block.HEALTH -= 1
			did_dig = true
			
		if did_dig:
			AUDIO.play_hit()
			LAST_DIG = cur_time
		
	s.set_linear_velocity(lv)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var sprite = get_node("RightSprite")
	var raycast = get_node("FloorCast")
	var block = raycast.get_collider()
	
	if block and block.has_method("kill"):
		block.kill(self)
	
	if ANIM != sprite.animation:
		sprite.animation = ANIM
		
	# Set score
	if DEAD:
		return
	
	var score_lbl = get_node("/root/Node2D/UpScore")
	
	SCORE = -int((INIT_Y - self.position.y) / 32) - 6
	
	if SCORE < 0:
		SCORE = 0
	
	score_lbl.text = str(SCORE)
	pass
