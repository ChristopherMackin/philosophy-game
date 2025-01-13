extends TopAction

class_name PermanentlyRemoveAndPlayTopAction

@export var pose_filters : Array[Pose]

func invoke():
	var ac = manager.active_contestant
	var iac = manager.inactive_contestant
	
	var tops : Array = iac.hand.filter(func(top : Top): return pose_filters.has(top.data.pose))
	if tops.size() <= 0:
		return
	
	var top = await ac.select_top(tops, "permanent_removal")
	
	iac.discard_top(top)
	iac.deck.remove_from_deck(top)
	
	await manager.play_top(top)
