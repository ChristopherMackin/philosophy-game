@tool
extends ConditionEffect

class_name RuleConditionStatusEffect

@export var rule: Rule

func check() -> bool:
	var manager = contestant.manager
	return rule.check(manager.blackboard.get_query())
