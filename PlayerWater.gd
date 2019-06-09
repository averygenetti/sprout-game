extends Node2D

onready var utility = get_node("/root/Utility")

func _process(delta):
	get_node("well").visible = utility.get_main().water