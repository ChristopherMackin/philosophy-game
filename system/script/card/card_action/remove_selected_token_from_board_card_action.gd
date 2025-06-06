extends CardAction

class_name RemoveSelectedTokenFromBoard

@export var suit_filter : Array[Suit]

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	var selectable_tokens : Array[Token]
	
	if suit_filter.size() > 0:	
		for suit in suit_filter:
			selectable_tokens.append_array(manager.suit_track_dictionary[suit.name])
	else:
		for key in manager.suit_track_dictionary:
			var track = manager.suit_track_dictionary[key]
			selectable_tokens.append_array(track)
	
	if selectable_tokens.size() <= 0: return true
	
	var response = await player.select(SelectionRequest.new(
		selectable_tokens,
		Const.SelectionAction.SINGLE,
		Const.SelectionType.TOKEN
	))
	
	await manager.remove_token_from_suit_track(response.data)
	
	return true
