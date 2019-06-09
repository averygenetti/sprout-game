extends Node

var height = 0
var maxHeight = 10
var age = 0
var wet
var dry
var dead = false

func _ready():
	wet = false
	dry = false

func _process(delta):
	var tilemap = get_tree().get_current_scene().get_node("Plants")
	var tilemapVector = tilemap.world_to_map(self.position)

	if wet:
		tilemap.set_cell(tilemapVector.x, tilemapVector.y, 14)
	else:
		tilemap.set_cell(tilemapVector.x, tilemapVector.y, 8)

	
	if height > maxHeight:
		height = maxHeight
	
	for i in range(maxHeight):
		var tile
		var y = tilemapVector.y + (i + 1)*-1

		if !dead:
			if height == i:
				if dry:
					tile = 16
				else:
					tile = 11
			elif height > i:
				if dry:
					tile = 15
				else:
					tile = 1
			else:
				tile = -1
		else:
			tile = -1
			
		tilemap.set_cell(tilemapVector.x, y, tile)

func progressDay():
	age += 1
	if wet:
		dry = false
		wet = false
		if height < maxHeight:
			height += 1
		else:
#			Add a seed here
			pass
	else:
		if dry:
			height = 0
			dead = true
		else:
			dry = true