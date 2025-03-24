extends CardAction

class_name ScryAndAddToHandCardAction

@export var which_contestant : Const.WhichContestant
@export var amount : int
@export var suit : Suit
@export var modifier : CardCostModifier

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.draw_pile.size() <= 0: return
	
	var viewable_cards = contestant.draw_pile.slice(0, amount if amount <= contestant.draw_pile.size() else contestant.draw_pile.size())
	
	await player.select(SelectionRequest.new(
		viewable_cards,
		"scry_and_add_to_hand",
		which_contestant,
		Const.SelectionAction.VIEW
	))
	
	var cards_to_add = viewable_cards.filter(func(x): return x.suit == suit)
	
	for card_to_add: Card in cards_to_add:
		contestant.draw_specified_card(card_to_add)
		if modifier: card_to_add.cost_modifiers.append(modifier)
