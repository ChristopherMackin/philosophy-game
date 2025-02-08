extends TopAction

class_name AddTopToHandPileTopAction

@export var top_data : TopData
@export var amount : int = 1

func invoke(player : Contestant, manager : DebateManager):
	for i in amount:
		player.hand.append(Top.new(top_data, manager))
