extends CardAction

class_name RemoveTokenFromBoardCardAction

@export var card_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var selectable_tokens : Array[Token]
	
	if card_filter.size() > 0:	
		for suit in card_filter:
			selectable_tokens.append_array(manager.suit_track_dictionary[suit.name])
	else:
		for key in manager.suit_track_dictionary:
			var track = manager.suit_track_dictionary[key]
			selectable_tokens.append_array(track)
	
	var selected_token = await player.select(SelectionRequest.new(
		selectable_tokens,
		"remove_token_from_board",
	))
	
	await manager.remove_token_from_suit_track(selected_token)
