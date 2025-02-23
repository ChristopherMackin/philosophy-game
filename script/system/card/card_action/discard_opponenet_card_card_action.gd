extends CardAction

class_name DiscardOpponentTopCardAction

@export var suit_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	if opponent.hand.size() <= 0:
		return
	
	var selectable_cards : Array[Card]
	
	if suit_filter.size() > 0:
		selectable_cards.append_array(opponent.hand.filter(func(card): return suit_filter.has(card.suit)))
	else:
		selectable_cards = opponent.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_card = await player.select(
		opponent.hand,
		"discard_opponent_top",
	)
	
	opponent.discard_card(selected_card)
