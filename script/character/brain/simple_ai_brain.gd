extends Brain

class_name SimpleAiBrain

func select(options : Array, what : String, type : String, visible_to_player : bool = true):
	return options[randi() % options.size()]
