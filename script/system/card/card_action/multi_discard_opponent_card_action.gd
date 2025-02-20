extends CardAction

class_name MultiDiscardOpponentCardAction

var suit_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if opponent.hand.size() <= 0:
		return
	
	var selectable_cards : Array[Card]
	
	if suit_filter.size() > 0:
		selectable_cards.append_array(opponent.hand.filter(func(card): return suit_filter.has(card.data.suit)))
	else:
		selectable_cards = opponent.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_cards = await player.select(
		opponent.hand,
		"multi_discard_opponent_hand",
		true
	)
	
	for selected_card in selected_cards:
		opponent.discard_card(selected_card)

