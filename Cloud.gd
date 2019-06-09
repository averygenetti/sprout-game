extends Sprite

export var speed = 0.1
var movement = 0

func _process(delta):
	movement += speed
	
	if movement >= 1:
		position.x += 1
		movement = 0

	if position.x >= 240:
		position.x = -40