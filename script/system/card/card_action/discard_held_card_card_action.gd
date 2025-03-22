extends CardAction

class_name DiscardHeldCardCardAction

var which_contestant : Const.WhichContestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	var held_card = contestant.held_card
	
	if !held_card:
		return
	
	contestant.held_card = null
	contestant.discard_card(held_card)
