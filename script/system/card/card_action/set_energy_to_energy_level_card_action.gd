extends CardAction

class_name SetEnergyToEnergyLevelCardAction

@export var which_contestant : Constants.Contestant

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	if contestant.current_energy <= contestant.energy_level:
		contestant.current_energy = contestant.energy_level

