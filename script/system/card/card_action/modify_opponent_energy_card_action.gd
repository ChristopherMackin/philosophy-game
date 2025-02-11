extends CardAction

class_name ModifyOpponentEnergyCardAction

@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	manager.get_opponent(player).current_energy += amount
	if manager.get_opponent(player).current_energy <= 0:
		manager.get_opponent(player).current_energy = 0
