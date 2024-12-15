extends TopAction

class_name OpponentEnergyTopAction

@export var amount : int

func invoke(manager: DebateManager):
	manager.inactive_contestant.current_energy += amount
	if manager.inactive_contestant.current_energy <= 0:
		manager.inactive_contestant.current_energy = 0
