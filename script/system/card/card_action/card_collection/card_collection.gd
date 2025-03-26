extends Resource

class_name CardCollection

var caller: Card
var player: Contestant
var manager: DebateManager

func init(caller: Card, player: Contestant, manager : DebateManager):
	self.caller = caller
	self.player = player
	self.manager = manager

func get_card_collection() -> Array[Card]:
	return []

func remove_card_from_collection(card: Card):
	pass

func add_card_to_collection(card: Card):
	pass
