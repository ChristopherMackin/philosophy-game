extends Resource

class_name CardCollectionContainer

var caller: Card
var player: Contestant
var manager: DebateManager
var card_collection : CardCollection

func init(caller: Card, player: Contestant, manager : DebateManager):
	self.caller = caller
	self.player = player
	self.manager = manager

func get_collection_cards() -> Array[Card]:
	return card_collection.get_cards()

func add_card_to_collection(card: Card) -> bool:
	return true
