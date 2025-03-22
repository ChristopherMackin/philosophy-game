extends CardAction

class_name ChangeCardSuitCardAction

@export var which_contestant : Const.WhichContestant
@export var suits : Array[Suit]
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
	
	var card_response = await player.select(SelectionRequest.new(
		selectable_cards,
		"change_card_suit",
		which_contestant
	))
	
	if suits.size() <= 0:
		suits = manager.debate_settings.suits
	
	var suit_response = await player.select(SelectionRequest.new(
		suits,
		"change_card_suit",
		which_contestant,
		Const.SelectionAction.SINGLE,
		Const.SelectionType.SUIT
	))
	
	card_response.data.suit = suit_response.data
