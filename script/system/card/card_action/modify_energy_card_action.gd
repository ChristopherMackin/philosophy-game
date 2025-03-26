extends CardAction

class_name ModifyEnergyCardAction

@export var which_contestant : Const.WhichContestant
@export var amount : int

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	contestant.current_energy += amount
	if contestant.current_energy < 0:
		contestant.current_energy = 0
