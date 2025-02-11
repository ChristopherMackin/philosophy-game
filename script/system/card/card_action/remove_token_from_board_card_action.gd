extends CardAction

class_name RemoveCardFromBoardCardAction

@export var allowedSuits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var selectable_cards : Array[Card]
	
	for suit in allowedSuits:
		selectable_cards.append_array(manager.suit_track_dictionary[suit.name])
	
	var selected_card = await player.select(
		selectable_cards,
		"board_card_removal",
		true
	)
	
	manager.remove_token_from_suit_track(selected_card)
