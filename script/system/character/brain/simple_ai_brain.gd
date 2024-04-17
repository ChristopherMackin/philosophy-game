extends Brain

class_name SimpleAiBrain

func think():
	return contestant.hand[randi() % contestant.hand.size()]
