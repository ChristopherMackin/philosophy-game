extends TopAction

class_name AddTopToDeckTopAction

@export var top_data : TopData
@export var amount : int = 1

func invoke(top : Top, player : Contestant, manager : DebateManager):
	for i in amount:
		player.add_to_deck(Top.new(top_data, manager))
