extends Brain

class_name SimpleAiBrain

func pick_card() -> Card:
	return contestant.hand[randi() % contestant.hand.size()]
