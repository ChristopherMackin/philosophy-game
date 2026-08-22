@abstract
class_name CostCardStatusEffect
extends CardStatusEffect

func modify_cost(base_cost : int, _manager : DebateManager) -> int:
	return base_cost

func apply(card: Card):
	super.apply(card)
	card.cost_status_effects.add(self)
	
func remove(card: Card):
	super.remove(card)
	card.cost_status_effects.remove(self)
