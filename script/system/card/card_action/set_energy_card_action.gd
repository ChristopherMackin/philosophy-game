extends CardAction

class_name SetEnergyCardAction

@export var which_contestant : Const.WhichContestant
@export var amount : int

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	contestant.current_energy = amount
	
	return true
