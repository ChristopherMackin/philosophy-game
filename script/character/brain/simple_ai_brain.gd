extends Brain

class_name SimpleAiBrain

func select_top(top_array : Array[Top], what : String, visible_to_player : bool = true) -> Top:
	return top_array[randi() % top_array.size()]
