extends CardAction

class_name Energize

@export var amount : int

func positive_action(manager: DebateManager):
	manager.active_contestant.current_energy += amount;

func negative_action(manager: DebateManager):
	manager.active_contestant.current_energy -= amount;
