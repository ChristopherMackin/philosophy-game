extends TopAction

class_name DuplicateTopAction

@export var amount : int

func invoke(top : Top, player : Contestant, manager : DebateManager):
	for i in amount:
		await player.play_top_cost_override(top, 0, false)
