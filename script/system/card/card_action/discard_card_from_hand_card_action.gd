extends CardAction

class_name DiscardCardFromHandCardAction

@export var which_contestant : Constants.Contestant
@export var suit_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if suit_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return suit_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_card = await player.select(
		selectable_cards,
		"discard_card_from_hand",
	)
	
	contestant.discard_card(selected_card)
