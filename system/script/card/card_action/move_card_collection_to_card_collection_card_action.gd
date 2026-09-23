@tool
extends CardAction

class_name MoveCardCollectionToCardCollectionCardAction

@export var from_collection : CardCollectionContainer
@export var to_collection : CardCollectionContainer
@export_enum("Move", "Duplicate", "Trade") var mode: int = 0
@export var keep_status_effect:= true

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	match mode:
		0: return await _move(caller, player, manager)
		1: return await _duplicate(caller, player, manager)
		2: return await _trade(caller, player, manager)
	
	return false

func _move(caller: Card, player: Contestant, manager: DebateManager) -> bool:
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	var from_collection_cards = await from_collection.get_collection_cards()
	
	for card in from_collection_cards:
		to_collection.add_card_to_collection(card)
	
	manager.blackboard.add_flag(Flag.ACTION_MOVED_CARDS_FROM, from_collection_cards, Blackboard.ExpirationToken.ON_ACTION_END)
	manager.blackboard.add_flag(Flag.ACTION_MOVED_CARDS_TO, to_collection, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true


func _duplicate(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	var from_collection_cards = await from_collection.get_collection_cards()
	
	for card: Card in from_collection_cards:
		to_collection.add_card_to_collection(card.duplicate(keep_status_effect))
	
	manager.blackboard.add_flag(Flag.ACTION_DUPLICATE_CARDS_FROM, from_collection_cards, Blackboard.ExpirationToken.ON_ACTION_END)
	manager.blackboard.add_flag(Flag.ACTION_DUPLICATE_CARDS_TO, to_collection, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true

func _trade(caller : Card, player : Contestant, manager : DebateManager):
	from_collection.init(caller, player, manager)
	to_collection.init(caller, player, manager)
	
	var cards_1 := await from_collection.get_collection_cards()
	var cards_2 := await to_collection.get_collection_cards()
	
	var size = cards_1.size() if cards_1.size() <= cards_2.size() else cards_2.size()
	
	for i in size:
		var card_1 = cards_1[i]
		var card_2 = cards_2[i]
		
		var index_1 = card_1.collection.get_card_index(card_1)
		var index_2 = card_2.collection.get_card_index(card_2)
		
		var collection_1 = card_1.collection
		var collection_2 = card_2.collection
		
		collection_1.insert(index_1, card_2)
		collection_2.insert(index_2, card_1)
	
	return true
