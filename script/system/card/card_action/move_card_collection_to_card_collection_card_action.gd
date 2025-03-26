@tool
extends CardAction

class_name MoveCardCollectionToCardCollectionCardAction

@export var from_collection : CardCollection
@export var to_collection : CardCollection

func invoke(caller : Card, player : Contestant, manager : DebateManager):	
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	for card in from_collection.get_card_collection():
		if !to_collection.add_card_to_collection(card): continue
		from_collection.remove_card_from_collection(card)
