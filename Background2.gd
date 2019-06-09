extends Node2D

onready var utility = get_node("/root/Utility")

func _process(delta):
	var weather = utility.todays_weather

	if utility.todays_weather == 1:
		visible = false
	else:
		visible = true