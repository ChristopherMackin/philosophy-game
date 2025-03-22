extends CardAction

class_name MultiDiscardCardFromHand

@export var which_contestant : Constants.WhichContestant
var card_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.WhichContestant.SELF else manager.get_opponent(player)
	
	if contestant.hand.size() <= 0:
		return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var response = await player.select(SelectionRequest.new(
		selectable_cards,
		"multi_discard_opponent",
	))
	
	for selected_card in response.data:
		contestant.discard_from_hand(selected_card)

