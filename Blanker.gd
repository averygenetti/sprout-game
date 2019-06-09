extends AnimatedSprite

var opacity = 0
var targetOpacity = 0

func _process(delta):
	if targetOpacity > opacity:
		opacity += 2*delta
	if targetOpacity < opacity:
		opacity -= 2*delta

	self.modulate = Color(0,0,0,opacity)
	
	if opacity == 0:
		visible = false
	else:
		visible = true