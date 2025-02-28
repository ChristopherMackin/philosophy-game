extends CardAction

class_name BanishAndPlayCardAction

@export var which_contestant : Constants.Contestant
@export var card_filters : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant : Contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	var cards : Array = contestant.hand.filter(func(x : Card): return card_filters.has(x.suit))
	if cards.size() <= 0:
		return
	
	var response = await player.select(SelectionRequest.new(
		cards, 
		"%s_permanently_remove_and_play" % Constants.Contestant.keys()[which_contestant]
	))
	
	contestant.remove_from_hand(response.data)
	contestant.deck.remove_from_deck(response.data)
	var modifier := ZeroCostModifier.new()
	modifier.priority = 999
	response.data.cost_modifiers.append(modifier)
	
	
