@tool
extends CostCardStatusEffect

class_name AdditiveCostCardStatusEffect

@export var amount : int = 1

func modify_cost(base_cost , manager : DebateManager):
	return base_cost + amount
