extends TopAction

class_name ModifyOpponentEnergyTopAction

@export var amount : int

func invoke(top : Top, player : Contestant, manager : DebateManager):
	manager.get_opponent(player).current_energy += amount
	if manager.get_opponent(player).current_energy <= 0:
		manager.get_opponent(player).current_energy = 0
