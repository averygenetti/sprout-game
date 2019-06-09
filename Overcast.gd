extends Sprite

onready var utility = get_node("/root/Utility")

func _process(delta):
	var weather = utility.todays_weather

	if utility.todays_weather == 1:
		visible = true
	else:
		visible = false