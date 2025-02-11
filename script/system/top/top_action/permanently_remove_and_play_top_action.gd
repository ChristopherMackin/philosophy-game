extends TopAction

class_name PermanentlyRemoveAndPlayTopAction

@export var pose_filters : Array[Pose]

func invoke(top : Top, player : Contestant, manager : DebateManager):
	var ac = player
	var iac = manager.get_opponent(player)
	
	var tops : Array = iac.hand.filter(func(top : Top): return pose_filters.has(top.data.pose))
	if tops.size() <= 0:
		return
	
	var selected_top = await ac.select_top(tops, "permanent_removal")
	
	iac.remove_top_from_hand(selected_top)
	iac.deck.remove_from_deck(selected_top)
	
	await ac.play_top_cost_override(selected_top)
