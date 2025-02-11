extends Resource

class_name DeckConfig

@export var card_data : CardData
@export var count : int

func _init(card_data : CardData = null, count : int = 0):
	self.card_data = card_data
	self.count = count
