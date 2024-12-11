extends Brain

class_name SimpleAiBrain

func pick_top() -> Top:
	return contestant.hand[randi() % contestant.hand.size()]
