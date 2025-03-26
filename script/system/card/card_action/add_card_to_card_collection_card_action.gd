extends CardAction

class_name AddCardToCardCollectionCardAction

@export var card_collection : CardCollection

@export var base : CardBase
@export var amount : int = 1

func invoke(caller : Card, player : Contestant, manager : DebateManager):	
	card_collection.init(caller, player, manager)
	
	for i in amount:
		var card = Card.new(base, manager)
		card.generate_token()
		
		card_collection.add_card_to_collection(card)
	
	manager.blackboard.add("action.added_card_base", base, Const.ExpirationToken.ON_ACTION_END)
