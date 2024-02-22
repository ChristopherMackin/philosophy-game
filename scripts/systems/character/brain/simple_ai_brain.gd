extends Brain

class_name SimpleAiBrain

func think():
	return contestant.hand_card_array[randi() % contestant.hand_card_array.size()]
