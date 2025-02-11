extends CardAction

class_name ModifyEnergyCardAction

@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	player.current_energy += amount
	if player.current_energy < 0:
		player.current_energy = 0
