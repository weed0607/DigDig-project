extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	const dirt_script = preload("res://scr/block.gd")
	const tnt_script = preload("res://scr/tnt.gd")
	const stone_script = preload("res://scr/stone.gd")
	const cloud_script = preload("res://scr/cloud.gd")
	const lava_script = preload("res://scr/lava.gd")
	const lava_tex = preload("res://tex/lava.png")
	const lava_broken_tex = preload("res://tex/lavalayerbrokenbg.png")
	const stone_tex = preload("res://tex/stone.png")
	const dirt_tex = preload("res://tex/dirt.png")
	const grass_tex = preload("res://tex/grassblock.png")
	const tuft1 = preload("res://tex/blades.png")
	const tuft2 = preload("res://tex/blades2.png")
	const tnt_tex = preload("res://tex/tnt.png")
	
	const tilesize = 16
	const tile_scale = 2
	
	const rows = 40
	const cols = 80
	
	var world = $SubViewportContainer/SubViewport
	
	# Draw some grass tufts
	for c in cols:
		var row = -(rows / 2) - 1
		var col = c - (cols / 2)
		var num = rng.randi_range(0, 3)
		
		# Create a sprite node
		var draw = false
		var sprite = Sprite2D.new()
		
		if num == 1:
			sprite.texture = tuft1
			draw = true
			
		if num == 3:
			sprite.texture = tuft2
			draw = true
			
		if draw:
			sprite.position = Vector2(16 * tile_scale * col, 16 * tile_scale * row)
			sprite.scale = Vector2(tile_scale, tile_scale)
			sprite.z_index = -1
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			world.add_child(sprite)
		
	# Create a bunch of tileNodes
	for r in rows:
		for c in cols:
			var row = r - (rows / 2)
			var col = c - (cols / 2)
			# 1/75 chance to spawn TNT
			var spawn_tnt = rng.randi_range(0, 50)
			var lava_layer = rows - r <= 6
			var empty_layer = rows - r >= 7 and rows - r <= 12

			var tileNode = RigidBody2D.new()
			var tileSprite = Sprite2D.new()
			var position = Vector2(16 * tile_scale * col, 16 * tile_scale * row)

			tileNode.set_position(position)

			tileSprite.scale = Vector2(tile_scale, tile_scale)
			
			if r == 0:
				tileSprite.texture = grass_tex
			else:
				tileSprite.texture = dirt_tex
				
			if !lava_layer and !empty_layer and spawn_tnt == 1 and r > 1:
				tileSprite.texture = tnt_tex
				tileNode.set_script(tnt_script)
				
			# Setup lava
			if lava_layer:
				tileSprite.texture = lava_tex
				tileNode.set_script(lava_script)
			
			tileSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

			tileNode.add_child(tileSprite)
			tileNode.name = "Dirt" + str(c) + "-" + str(r)

			tileNode.gravity_scale = 0
			tileNode.freeze = true

			var tileCol = CollisionShape2D.new()
			var tileRect = RectangleShape2D.new()

			tileRect.size = Vector2(32, 32)
			tileCol.shape = tileRect

			if tileNode.get_script() == null:
				tileNode.set_script(dirt_script)
				
			if empty_layer:
				#  Kill the layer
				if "LAYER" in tileNode:
					tileNode.LAYER = "lava"
					tileNode.HEALTH = 0
			
			tileNode.add_child(tileCol)

			world.add_child(tileNode)
			
	# After main pass, do rock generation pass
	for r in rows:
		for c in cols:
			if r <= 1 or rows - r < 13:
				continue
			
			var row = r - (rows / 2)
			var col = c - (cols / 2)
			var rand = rng.randi_range(0, 10)
			
			if rand != 1:
				continue
				
			var block_at = get_node("/root/Node2D/SubViewportContainer/SubViewport/Dirt" + str(col) + "-" + str(row))
			var neighbors = [
				[-1,  0],
				[ 0, -1], [0, 0], [ 0,  1],
				[ 1,  0],
			]
			
			for n in neighbors:
				var x = c + n[0]
				var y = r + n[1]
				
				if x < 0 or y < 0:
					continue
				
				var block = get_node("/root/Node2D/SubViewportContainer/SubViewport/Dirt" + str(x) + "-" + str(y))
				
				if block == null:
					continue
				
				var sprite = block.get_child(0)
				
				sprite.texture = stone_tex
				block.set_script(stone_script)

	# Create clouds :)
	for i in 75:
		var rand = rng.randi_range(0, 5)
		
		if rand != 1:
			continue
			
		var type = rng.randi_range(0, 5)
		var tex = load("res://tex/clouds" + str(type) + ".png")
		var x = rng.randi_range(-400, 700)
		var y = rng.randi_range(-700, -950)
		
		var sprite = Sprite2D.new()
		sprite.texture = tex
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.position = Vector2(x, y)
		sprite.scale = Vector2(tile_scale, tile_scale)
		
		sprite.set_script(cloud_script)
		
		world.add_child(sprite)
		
	
	print("Genertion finished!")
	
	get_node("SubViewportContainer2/SubViewport").world_2d = get_node("SubViewportContainer/SubViewport").world_2d
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Boot back to main menu if esc is pressed
	if Input.is_action_pressed("esc", true):
		get_tree().change_scene_to_file("res://menu.tscn")
	pass
