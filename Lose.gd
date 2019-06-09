extends Node2D

onready var utility = get_node("/root/Utility")

func _process(delta):
	if position.y <= 80 && utility.get_main().lose:
		position.y += delta*20