extends CardAction

class_name RemoveCardFromBoardCardAction

@export var allowedSuits : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var selectable_tokens : Array[Token]
	
	for suit in allowedSuits:
		selectable_tokens.append_array(manager.suit_track_dictionary[suit.name])
	
	var selected_token = await player.select(
		selectable_tokens,
		"board_token_removal",
		true
	)
	
	manager.remove_token_from_suit_track(selected_token)
