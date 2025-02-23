extends CardAction

class_name DiscardAndPlayTokenCardAction

@export var suit_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if player.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if suit_filter.size() > 0:
		selectable_cards.append_array(player.hand.filter(func(card): return suit_filter.has(card.suit)))
	else:
		selectable_cards = player.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_card = await player.select(
		selectable_cards,
		"discard_and_play_token",
	)
	
	await manager.add_token_to_suit_track(card.token, card.suit)
	await player.discard_card(selected_card)

