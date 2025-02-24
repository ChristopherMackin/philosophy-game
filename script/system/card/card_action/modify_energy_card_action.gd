extends CardAction

class_name ModifyEnergyCardAction

@export var which_contestant : Constants.Contestant
@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	contestant.current_energy += amount
	if contestant.current_energy < 0:
		contestant.current_energy = 0
