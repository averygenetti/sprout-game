extends Node

const GROUND = 0
const GROUND_TILLED = 8
const STALK_1 = 1
const STALK_2 = 11
const STALK_1_DRY = 15
const STALK_2_DRY = 16

var todays_weather

func _ready():
	todays_weather = get_main().weather[0]

func get_main():
	return get_tree().get_root().get_node("Level")

func get_player_obj():
	return get_tree().get_current_scene().get_node("Player")

func get_player_collision():
	return get_player_obj().get_node("PlayerCollision")

func get_node_from_tree(name):
	return get_tree().get_current_scene().get_node(name)

# Get a tile index based on tilemap coordinates
func get_tile(vector, tilemap):
	return tilemap.get_cellv(vector)

# given a tilemap position, is it the ground?
func is_ground(vector):
	var tile = get_tile(vector, get_node_from_tree("Level"))
	return tile == GROUND || tile == GROUND_TILLED

# given a tilemap position, is it a stalk?
func is_stalk(vector):
	var tile = get_tile(vector, get_node_from_tree("Plants"))
	return tile == STALK_1 || tile == STALK_2 || tile == STALK_1_DRY || tile == STALK_2_DRY

func get_plant_at_coordinates(vector):
	var plants = get_node_from_tree("Plants")
	
	for i in plants.get_children():
		if i.position.x >= vector.x - 4 && i.position.x < vector.x + 4 && i.position.y >= vector.y - 4 && i.position.y < vector.y + 4:
			return i
			
func fade_out():
	var blanker = get_node_from_tree("UI").get_node("Blanker")
	var rain = get_node_from_tree("UI").get_node("rain")
	
	blanker.targetOpacity = 1
#	rain.targetVolume = -30
	
func fade_in():
	var blanker = get_node_from_tree("UI").get_node("Blanker")
	
	blanker.targetOpacity = 0

func progress_day():
	var Plants = get_node_from_tree("Plants")
	var Player = get_node_from_tree("Player")
	var camp = get_node_from_tree("Objects").get_node("Camp")
	var main = get_main()
	var weatherOverlay = get_node_from_tree("UI").get_node("WeatherOverlay")
	var wells = get_node_from_tree("Objects").get_node("Wells").get_children()

	Player.cantSleep = true
	fade_out()	
	yield(get_tree().create_timer(1), "timeout")
	Plants.progressDay();
	Player.position = camp.position + Vector2(4, 4)
	fade_in()
	
	main.food -= 0.5
	main.days += 1

	var weather = advance_weather()
	todays_weather = weather[0]
	weatherOverlay.set_weather(todays_weather)
	
	if todays_weather == 1:
		for i in wells:
			i.water = i.maxWater
		for i in Plants.get_children():
			i.wet = true
		Player.visible = false
	else:
		Player.visible = true
	
	Player.cantSleep = false

func advance_weather():
	var weather = get_main().weather
	var first_weather = weather.pop_front()
	weather.insert(weather.size(), first_weather)
	update_weather()
	return weather
	
func update_weather():
	var weather = get_main().weather
	get_node_from_tree("UI").get_node("Forecast").set_weather(weather)
	return weather
	
func is_it_raining():
	return get_main().weather[0] == 1