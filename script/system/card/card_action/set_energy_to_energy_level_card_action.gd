extends CardAction

class_name SetEnergyToEnergyLevelCardAction

@export var which_contestant : Constants.WhichContestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Constants.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.current_energy <= contestant.energy_level:
		contestant.current_energy = contestant.energy_level

