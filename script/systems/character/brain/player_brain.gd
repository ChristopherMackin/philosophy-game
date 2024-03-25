extends Brain

class_name PlayerBrain

signal card_played

func think():
	var card = await card_played
	print("PLAY")
	return card

func play_card(card):
	card_played.emit(card)
