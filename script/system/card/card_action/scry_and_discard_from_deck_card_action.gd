extends CardAction

class_name ScryAndDiscardFromDeckCardAction

@export var which_contestant : Const.WhichContestant
@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.draw_pile.size() <= 0: return
	
	var viewable_cards = contestant.draw_pile.slice(0, amount if amount <= contestant.draw_pile.size() else contestant.draw_pile.size())
	
	await player.view(
		viewable_cards,
		"scry_and_discard_from_deck"
	)
