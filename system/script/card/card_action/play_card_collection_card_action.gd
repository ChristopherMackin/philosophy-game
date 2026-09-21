class_name PlayCardCollectionCardAction
extends CardAction

@export var collection_container : CardCollectionContainer


func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	collection_container.init(caller, player, manager)
	
	return true
