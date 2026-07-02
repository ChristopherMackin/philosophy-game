@tool
extends ConditionEffect

class_name RuleConditionEffect

@export var rule: Rule

func check() -> bool:
	var manager = contestant.manager
	return rule.check(manager.blackboard.get_query())
