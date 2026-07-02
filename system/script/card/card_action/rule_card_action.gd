extends CardAction

class_name CheckBlackboardRuleCardAction

@export var rule : Rule

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	return rule.check(manager.blackboard.get_query())
