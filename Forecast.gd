extends Node2D

func set_weather(weatherArray):
	var daysArray = get_children()
	var i = 0;
	
	for j in weatherArray:
		daysArray[i].set_frame(j)
		i += 1