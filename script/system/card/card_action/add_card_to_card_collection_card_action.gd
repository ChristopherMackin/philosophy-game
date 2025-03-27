extends CardAction

class_name AddCardToCardCollectionContainerCardAction

@export var collection_container : CardCollectionContainer

@export var base : CardBase
@export var amount : int = 1

func invoke(caller : Card, player : Contestant, manager : DebateManager):	
	collection_container.init(caller, player, manager)
	
	for i in amount:
		var card = Card.new(base, manager)
		card.generate_token()
		
		collection_container.add_card_to_collection(card)
	
	manager.blackboard.add("action.added_card_base", base, Const.ExpirationToken.ON_ACTION_END)
