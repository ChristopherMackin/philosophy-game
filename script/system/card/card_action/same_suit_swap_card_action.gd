extends CardAction

class_name SameSuitSwapCardAction

@export var which_contestant : Constants.WhichContestant
@export var card_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Constants.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var response = await player.select(SelectionRequest.new(
		selectable_cards,
		"%s_same_suit_swap" % Constants.WhichContestant.keys()[which_contestant]
	))
	
	var selected_card = response.data
	
	var cards = contestant.draw_pile.filter(func(x): return x.suit == selected_card.suit && x._base != selected_card._base)
	if cards.size() <= 0: return
	
	var index = contestant.draw_pile.find(cards[0])
	contestant.draw_at_index(index)
	contestant.remove_from_hand(selected_card)
	contestant.add_to_draw_pile(selected_card)
