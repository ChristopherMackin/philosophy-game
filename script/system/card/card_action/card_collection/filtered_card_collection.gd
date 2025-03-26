extends CardCollection

class_name FilteredCardCollection

@export var card_collection: CardCollection
@export var card_array_filters: Array[CollectionFilter]

func init(caller: Card, player: Contestant, manager : DebateManager):
	super(caller, player, manager)
	card_collection.init(caller, player, manager)

func get_card_collection() -> Array[Card]:
	var card_array := card_collection.get_card_collection()
	
	for filter in card_array_filters:
		card_array = filter.filter(card_array, caller, player, manager)
	
	return card_array

func remove_card_from_collection(card: Card):
	card_collection.remove_card_from_collection(card)

func add_card_to_collection(card: Card):
	card_collection.add_card_to_collection(card)
