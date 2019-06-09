extends Area2D

onready var utility = get_node("/root/Utility")

func _ready():
	self.connect("area_entered",self,"_on_Area2D_enter")

func _on_Area2D_enter(area):
	if area == utility.get_player_collision():
		utility.get_main().seeds += 1
		queue_free()