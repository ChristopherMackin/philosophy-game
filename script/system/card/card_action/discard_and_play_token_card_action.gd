extends CardAction

class_name DiscardAndPlayTokenCardAction

@export var which_contestant : Const.WhichContestant
@export var card_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var response = await player.select(SelectionRequest.new(
		selectable_cards,
		"%discard_and_play_token",
		which_contestant
	))
	
	await manager.add_token_to_suit_track(card.token, card.suit)
	await contestant.discard_from_hand(response.data)
