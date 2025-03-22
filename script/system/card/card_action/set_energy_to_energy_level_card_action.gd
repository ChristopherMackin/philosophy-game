extends CardAction

class_name SetEnergyToEnergyLevelCardAction

@export var which_contestant : Const.WhichContestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.current_energy <= contestant.energy_level:
		contestant.current_energy = contestant.energy_level
