extends CardAction

class_name SetEnergyToEnergyLevelCardAction

@export var which_contestant : Constants.WhichContestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.WhichContestant.SELF else manager.get_opponent(player)
	
	if contestant.current_energy <= contestant.energy_level:
		contestant.current_energy = contestant.energy_level

