extends Resource

class_name CardCollectionContainer

var caller: Card
var player: Contestant
var manager: DebateManager
var card_collection : CardCollection

@export var collection_filters: Array[CollectionFilter]

func init(caller: Card, player: Contestant, manager : DebateManager):
	self.caller = caller
	self.player = player
	self.manager = manager

func get_collection_cards() -> Array[Card]:
	var card_array = _get_unfiltered_collection()
	
	for filter in collection_filters:
		card_array = await filter.filter(card_array, caller, player, manager)
	
	return card_array
	
func _get_unfiltered_collection() -> Array[Card]:
	return card_collection.get_cards()

func add_card_to_collection(card: Card):
	pass
