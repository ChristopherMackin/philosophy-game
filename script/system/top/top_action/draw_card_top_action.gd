extends TopAction

class_name DrawCardTopAction

@export var draw_amount : int

func invoke(player : Contestant, manager : DebateManager):
	player.draw_number_of_tops(draw_amount)
