extends Resource

class_name CardCostModifier

@export var priority : int
@export var can_expire : bool = false
@export var turn_lifetime : int = -1
var current_turn : int = 0

func modify_cost(base_cost : int, manager : DebateManager) -> int:
	return base_cost
