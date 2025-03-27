extends CardCollectionContainer

class_name FilteredCollectionContainer

@export var collection_container: CardCollectionContainer
@export var collection_filters: Array[CollectionFilter]

func init(caller: Card, player: Contestant, manager : DebateManager):
	super(caller, player, manager)
	collection_container.init(caller, player, manager)

func get_collection_cards() -> Array[Card]:
	var card_array := collection_container.get_collection_cards()
	
	for filter in collection_filters:
		card_array = await filter.filter(card_array, caller, player, manager)
	
	return card_array

func add_card_to_collection(card: Card):
	collection_container.add_card_to_collection(card)
