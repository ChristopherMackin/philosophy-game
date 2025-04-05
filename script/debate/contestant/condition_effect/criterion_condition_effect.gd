extends ConditionEffect

class_name CriterionConditionEffect

@export var criterion: Criterion

func check(manager : DebateManager) -> bool:
	return criterion.check(manager.blackboard.get_query())
