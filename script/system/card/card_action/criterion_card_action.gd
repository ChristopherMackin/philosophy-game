extends CardAction

class_name CheckBlackboardCriterionCardAction

@export var criterion : Criterion

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	return criterion.check(manager.blackboard.get_query())
