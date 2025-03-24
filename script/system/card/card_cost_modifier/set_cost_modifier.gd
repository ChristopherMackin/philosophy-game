extends CardCostModifier

class_name SetCostModifier

@export var amount : int = 0

func modify_cost(base_cost , manager : DebateManager):
	return amount
