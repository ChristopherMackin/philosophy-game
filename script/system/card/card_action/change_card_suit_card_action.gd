extends CardAction

class_name ChangeCardSuitCardAction

@export var which_contestant : Constants.Contestant
@export var suits : Array[Suit]
@export var card_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_card : Card = await player.select(
		selectable_cards,
		"%s_change_card_suit" % Constants.Contestant.keys()[which_contestant]
	)
	
	if suits.size() <= 0:
		suits = manager.debate_settings.suits
	
	var selected_suit = await player.select(
		suits,
		"%s_change_card_suit" % Constants.Contestant.keys()[which_contestant],
		"suit"
	)
	
	selected_card.suit = selected_suit

