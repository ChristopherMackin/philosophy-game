extends TopAction

class_name ModifyEnergyTopAction

@export var amount : int

func invoke(top : Top, player : Contestant, manager : DebateManager):
	player.current_energy += amount
	if player.current_energy < 0:
		player.current_energy = 0
