extends TileMap

func progressDay():
	for i in self.get_children():
		i.progressDay()