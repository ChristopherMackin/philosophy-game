extends Brain

class_name PlayerBrain

signal card_played

func think():
	return await card_played

func play_card(card):
	card_played.emit(card)
