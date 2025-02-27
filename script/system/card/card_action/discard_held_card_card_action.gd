extends CardAction

class_name DiscardHeldCardCardAction

var which_contestant : Constants.Contestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	var held_card = contestant.held_card
	
	if !held_card:
		return
	
	contestant.held_card = null
	contestant.discard_card(held_card)
