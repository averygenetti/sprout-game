extends Node

var food = 3
var maxFood = 5
var special_food = 0
var days = 1
var water = false
var seeds = 0
var win = false
var lose = false

# weather: 0 = sun, 1 = rain, 2 = snow, 3 = wind

var weather = [0,0,1,0,0]

func _ready():
	get_viewport().set_size_override(true, OS.get_window_size()*1/3)
	get_viewport().set_size_override_stretch(true)

func _process(delta):
	if food < 0:
		lose = true
	else:
		lose = false

		if special_food >= 1:
			win = true
		else:
			win = false