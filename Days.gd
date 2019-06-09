extends Label

onready var utility = get_node("/root/Utility")

func _process(delta):
	text = "Day " + str(utility.get_main().days)