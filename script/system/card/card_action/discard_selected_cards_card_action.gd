extends CardAction

class_name DiscardSelectedCardsCardAction

@export var which_contestant: Const.WhichContestant
@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	var selected_cards = manager.blackboard.get_value("action.%s" % key)
	
	if selected_cards == null || selected_cards.size() <= 0: return true
	
	for selected_card in selected_cards:
		contestant.discard_card(selected_card)
	
	return true
