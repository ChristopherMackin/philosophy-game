extends CardAction

class_name CheckCriterionCardAction

@export var criterion : Criterion

func invoke(card : Card, player : Contestant, manager : DebateManager) -> bool:
	return criterion.check(manager.blackboard.get_query())
