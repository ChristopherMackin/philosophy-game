extends CardAction

class_name RemoveCardFromBoardCardAction

@export var suit_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var selectable_tokens : Array[Token]
	
	if suit_filter.size() > 0:	
		for suit in suit_filter:
			selectable_tokens.append_array(manager.suit_track_dictionary[suit.name])
	else:
		for key in manager.suit_track_dictionary:
			var track = manager.suit_track_dictionary[key]
			selectable_tokens.append_array(track)
	
	var selected_token = await player.select(
		selectable_tokens,
		"board_token_removal",
		true
	)
	
	await manager.remove_token_from_suit_track(selected_token)
