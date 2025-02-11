extends Object

class_name Card

var data : CardData
var manager : DebateManager

var cost : int :
	get: return data.get_cost(manager)

func _init(card_data: CardData, manager : DebateManager):
	data = card_data
	self.manager = manager
