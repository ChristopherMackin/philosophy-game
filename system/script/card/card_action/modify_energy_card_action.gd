extends CardAction

class_name ModifyEnergyCardAction

@export var which_contestant : Const.WhichContestant
@export var amount: int
@export var operation: EnumMath.Operation

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	var contestant := Const.get_contestant(player, manager.get_opponent(player), which_contestant)
	
	contestant.current_energy = EnumMath.evaluate(contestant.current_energy, amount, operation)
	if contestant.current_energy < 0:
		contestant.current_energy = 0
	
	return true
