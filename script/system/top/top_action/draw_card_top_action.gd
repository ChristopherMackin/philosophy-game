extends TopAction

class_name DrawCardTopAction

@export var draw_amount : int

func invoke(manager: DebateManager):
	manager.active_contestant.draw_number_of_tops(draw_amount)
