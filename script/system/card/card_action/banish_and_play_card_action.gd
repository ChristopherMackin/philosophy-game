extends CardAction

class_name BanishAndPlayCardAction

@export var which_contestant : Constants.Contestant
@export var card_filters : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	var cards : Array = contestant.hand.filter(func(x : Card): return card_filters.has(x.suit))
	if cards.size() <= 0:
		return
	
	var selected_card : Card = await player.select(SelectionRequest.new(
		cards, 
		"%s_permanently_remove_and_play" % Constants.Contestant.keys()[which_contestant]
	))
	
	contestant.remove_card_from_hand(selected_card)
	contestant.deck.remove_from_deck(selected_card)
	var modifier := ZeroCostModifier.new()
	modifier.priority = 999
	selected_card.cost_modifiers.append(modifier)
	
	await contestant.play_card(selected_card)
