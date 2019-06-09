extends Area2D

var isPlayerHere = false
var water = 3
var maxWater = 3

onready var utility = get_node("/root/Utility")

func _ready():
	self.connect("area_entered",self,"_on_Area2D_enter")
	self.connect("area_exited",self,"_on_Area2D_exit")
	
func _process(delta):
	get_node("WaterLevel").visible = !utility.is_it_raining() && isPlayerHere

func _on_Area2D_enter(area):
	if area == utility.get_player_collision():
		isPlayerHere = true
		get_node("WellHint").visible = water > 0

func _on_Area2D_exit(area):
	if area == utility.get_player_collision():
		isPlayerHere = false
		get_node("WellHint").visible = false