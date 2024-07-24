extends Brain

class_name PlayerBrain

signal top_played

func pick_top() -> Top:
	var top = await top_played
	return top

func play_top(top):
	top_played.emit(top)
