extends Label

onready var utility = get_node("/root/Utility")

func _process(delta):
	var seeds = utility.get_main().seeds
#	if seeds == 1:
#		text = "1 seed"
#	else:
#		text = str(seeds) + " seeds"
	text = str(seeds)