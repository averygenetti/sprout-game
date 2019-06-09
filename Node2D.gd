extends Node2D

onready var utility = get_node("/root/Utility")

func _process(delta):
	var main = utility.get_main()
	var foodCount = main.food
	
	for i in get_children():
		i.state = 0
		if foodCount >= 0.5:
			i.state = 0.5
		if foodCount >= 1:
			i.state = 1
		
		foodCount -= i.state