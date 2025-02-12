extends CardAction

class_name ModifyOpponentEnergyCardAction

@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var opponent = manager.get_opponent(player)
	
	opponent.current_energy += amount
	if opponent.current_energy <= 0:
		opponent.current_energy = 0
