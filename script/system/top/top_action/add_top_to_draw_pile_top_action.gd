extends TopAction

class_name AddTopToDrawPileTopAction

@export var top_data : TopData
@export var amount : int = 1

func invoke(top : Top, player : Contestant, manager : DebateManager):
	for i in amount:
		player.add_to_draw_pile(Top.new(top_data, manager))
