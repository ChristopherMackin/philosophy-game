extends CardAction

class_name AddHoldToHandCardAction

@export var which_contestant_hold : Const.WhichContestant
@export var which_contestant_hand : Const.WhichContestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var hold_contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant_hold)
	var hand_contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant_hand)
	
	if hold_contestant.held_card == null: return
	
	var held_card = hold_contestant.held_card
	hold_contestant.held_card = null
	
	hand_contestant.add_to_hand(held_card)
