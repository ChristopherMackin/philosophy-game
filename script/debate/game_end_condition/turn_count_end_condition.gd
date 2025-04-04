extends GameEndCondition

class_name TurnCountEndCondition

@export var turn_count = 20

func check_condition(manager: DebateManager):
	return manager.current_turn < turn_count
