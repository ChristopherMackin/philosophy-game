@tool
extends ConditionEffect

class_name CriterionConditionEffect

@export var criterion: Criterion

func check() -> bool:
	var manager = contestant.manager
	return criterion.check(manager.blackboard.get_query())
