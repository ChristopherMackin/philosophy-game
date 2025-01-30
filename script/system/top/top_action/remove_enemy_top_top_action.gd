extends TopAction

class_name RemoveEnemyTopTopAction

func invoke():
	if manager.inactive_contestant.hand.size() <= 0:
		return
	
	var top = await manager.active_contestant.select_top(
		manager.inactive_contestant.hand,
		"enemy_top_removal",
		true
	)
	
	manager.inactive_contestant.discard_top(top)
