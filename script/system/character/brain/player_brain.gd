extends Brain

class_name PlayerBrain

signal card_played

func pick_card() -> Card:
	var card = await card_played
	return card

func play_card(card):
	card_played.emit(card)
