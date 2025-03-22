extends CardAction

class_name ModifyEnergyCardAction

@export var which_contestant : Constants.WhichContestant
@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Constants.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	contestant.current_energy += amount
	if contestant.current_energy < 0:
		contestant.current_energy = 0
