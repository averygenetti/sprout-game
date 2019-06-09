extends Area2D

onready var utility = get_node("/root/Utility")

var state = 1

func _ready():
	self.connect("area_entered",self,"_on_Area2D_enter")

func _on_Area2D_enter(area):
	if area == utility.get_player_collision():
		utility.get_main().food += 1
		queue_free()

func _process(delta):
	if state == 0:
		get_node("fruit_full").visible = false
		get_node("fruit_half").visible = false
	
	if state == 0.5:
		get_node("fruit_full").visible = false
		get_node("fruit_half").visible = true
	
	if state == 1:
		get_node("fruit_full").visible = true
		get_node("fruit_half").visible = false