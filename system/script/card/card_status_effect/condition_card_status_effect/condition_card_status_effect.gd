@abstract
class_name ConditionCardStatusEffect
extends CardStatusEffect

@export var actions_filter: Array[CardAction]

func check(action: CardAction) -> bool:
	if !actions_filter || actions_filter.size() <= 0: return false
	
	return actions_filter.find_custom(func(x): return x.get_script() == action.get_script()) == -1

func apply(card: Card):
	super.apply(card)
	card.condition_status_effects.add(self)

func remove(card: Card):
	super.apply(card)
	card.condition_status_effects.remove(self)
