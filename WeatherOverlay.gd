extends AnimatedSprite

var weather = 0

func set_weather(w):
	weather = w
	
	if weather == 1:
		get_parent().get_node("rain").playing = true
	else:
		get_parent().get_node("rain").playing = false

func _process(delta):
	if weather == 1:
		modulate = Color(0.5,0.5,1,0.5)
		visible = true
	else:
		modulate = Color(1,1,1,1)
		visible = false