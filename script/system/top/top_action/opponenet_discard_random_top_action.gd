extends TopAction

class_name  OpponenetDiscardRandomTopAction

func invoke():
	if(manager.inactive_contestant.hand.size() < 0):
		return
	
	var i := randi_range(0, manager.inactive_contestant.hand.size() - 1)
	manager.inactive_contestant.discard_top(manager.inactive_contestant.hand[i])
