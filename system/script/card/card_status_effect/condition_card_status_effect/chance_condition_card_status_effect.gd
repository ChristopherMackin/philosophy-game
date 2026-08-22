class_name ChanceConditionCardStatusEffect
extends ConditionCardStatusEffect

@export_range(0, 100) var percentage_chance: int = 100

func check(action: CardAction) -> bool:
	return randi_range(0, 99) < percentage_chance if !super.check(action) else true
