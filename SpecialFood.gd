extends Node2D

onready var utility = get_node("/root/Utility")

func _process(delta):
	self.visible = utility.get_main().special_food >= 1