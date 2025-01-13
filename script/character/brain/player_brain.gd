extends Brain

class_name PlayerBrain

signal top_played

func select_top(top_array : Array[Top], what : String, visible_to_player : bool = true) -> Top:
	var top = await top_played
	return top

func play_top(top):
	top_played.emit(top)
