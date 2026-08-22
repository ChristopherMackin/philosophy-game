@tool
extends CostCardStatusEffect

class_name SetCostCardStatusEffect

@export var amount : int = 0

func modify_cost(base_cost , manager : DebateManager):
	return amount
