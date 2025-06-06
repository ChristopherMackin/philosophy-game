extends GameEndCondition

class_name EmptyHandEndCondition

func check_condition(manager: DebateManager):
	for c : Contestant in manager.contestants:
		if c.draw_pile.size() + c.hand.size() <= 0:
			return true
	
	return false
