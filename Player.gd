extends KinematicBody2D

onready var utility = get_node("/root/Utility")

# using export makes it possible to edit the variable in the inspector  
export(int) var tileSize = 8  
export(float) var movementThrottle = 0.15  

var velocity = Vector2()
var d = 0

var levelTilemap
var plantsTilemap

var cantSleep

func _ready():
	levelTilemap = utility.get_node_from_tree("Level")
	plantsTilemap = utility.get_node_from_tree("Plants")
	utility.update_weather()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	
	if !velocity.x:
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1

func do_movement():
	if velocity.x > 0 && can_move_right() || velocity.x < 0 && can_move_left() || velocity.y > 0 && can_move_down() || velocity.y < 0 && can_move_up():
		if velocity.x > 0:
			get_node("AnimatedSprite").set_flip_h(true)
		elif velocity.x < 0:
			get_node("AnimatedSprite").set_flip_h(false)
		self.move_and_collide(velocity*tileSize)
	d = movementThrottle

# Get the tile under the player
func get_current_tile(tileMap):
	return utility.get_tile(levelTilemap.world_to_map(self.position), tileMap)

func can_move_up():
	var vector = levelTilemap.world_to_map(self.position)
	return utility.is_stalk(vector) && utility.is_stalk(vector + Vector2(0,-1))

func can_move_down():
	var vector = levelTilemap.world_to_map(self.position)
	return utility.is_stalk(vector) && utility.is_stalk(vector + Vector2(0,1))

func can_move_left():
	return utility.is_ground(levelTilemap.world_to_map(self.position) + Vector2(-1, 1)) || utility.is_stalk(levelTilemap.world_to_map(self.position) + Vector2(-1, 0))

func can_move_right():
	return utility.is_ground(levelTilemap.world_to_map(self.position) + Vector2(1, 1)) || utility.is_stalk(levelTilemap.world_to_map(self.position) + Vector2(1, 0))

func can_plant():
	var coords = Vector2(self.position.x, self.position.y + 8)
	
	var plant = utility.get_plant_at_coordinates(self.position + Vector2(0, 8))
	var camp = utility.get_node_from_tree("Objects").get_node("Camp")
	var wells = utility.get_node_from_tree("Objects").get_node("Wells").get_children()
	
	if !utility.is_ground(levelTilemap.world_to_map(self.position) + Vector2(0, 1)):
		return false
	
	if utility.get_main().seeds == 0:
		return false
	
	if camp.isPlayerHere:
		return false
	for i in wells:
		if i.isPlayerHere:
			return false
	if plant:
		return false
	else:
		return true

func plant_seed():
	var coords = Vector2(self.position.x, self.position.y + 8)

	if can_plant():
		if utility.is_ground(utility.get_node_from_tree("Plants").world_to_map(coords)) && utility.get_main().seeds > 0:
			var Stalk = load("res://Stalk.tscn")
			var newStalk = Stalk.instance()
			
			newStalk.position = coords
			utility.get_node_from_tree("Plants").add_child(newStalk)
			d = movementThrottle
			utility.get_main().seeds -= 1

func sleep(force):	
	if !cantSleep:
		var camp = utility.get_node_from_tree("Objects").get_node("Camp")
		
		if camp.isPlayerHere || force:
			utility.progress_day()
			
			if utility.get_main().food < 0:
				utility.get_main().food = 0
				print("Game over")

func getWater():
	var wells = utility.get_node_from_tree("Objects").get_node("Wells").get_children()

	for i in wells:
		if i.isPlayerHere:
			if i.water && !utility.get_main().water:
				i.water -= 1
				utility.get_main().water = true
				d = movementThrottle

func can_water():
	var plant = utility.get_plant_at_coordinates(self.position + Vector2(0, 8))
	return plant && utility.get_main().water

func waterPlant():
	var plant = utility.get_plant_at_coordinates(self.position + Vector2(0, 8))
	if can_water():
		plant.wet = true
		utility.get_main().water = false
		d = movementThrottle

func restartLevel():
	get_tree().reload_current_scene()

func _process(delta):
	var main = utility.get_main()
	
	get_node("PlantHint").visible = can_plant()
	get_node("WaterHint").visible = can_water()
	
	get_input()
	# We've hit the throttle point for movement, so let's do a movement
	if d <= 0:
		if Input.is_key_pressed(KEY_R):
			restartLevel()
		if Input.is_key_pressed(KEY_X) && !main.win && !main.lose:
			sleep(true)
		if Input.is_key_pressed(KEY_Z) && !main.win && !main.lose:
			waterPlant()
			plant_seed()
			sleep(false)
			getWater()

		if velocity.abs() && !main.win && !main.lose && !cantSleep && utility.get_main().weather[0] == 0:
			do_movement()
	d -= delta