extends AnimatedSprite

func _process(delta):
	var well = get_parent()
	var frame = 3 - well.water
	set_frame(frame)