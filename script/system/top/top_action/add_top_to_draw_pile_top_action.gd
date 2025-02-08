extends TopAction

class_name AddTopToDrawPileTopAction

@export var top_data : TopData

func invoke(player : Contestant, manager : DebateManager):
	player.deck.add_to_draw_pile(Top.new(top_data, manager))
