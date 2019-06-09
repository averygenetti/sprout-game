extends Label

func _process(delta):
	var well = get_parent()
	text = str(well.water) + "/" + str(well.maxWater)