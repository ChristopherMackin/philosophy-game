extends CardAction

class_name DiscardCardCollectionCardAction

@export var card_collection : CardCollection
@export var which_contestant : Const.WhichContestant

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_card_collection()
		
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	for card in cards:
		contestant.discard_card(card)
		card_collection.remove_card_from_collection(card)
	
	manager.blackboard.add("action.discarded_cards", cards, Const.ExpirationToken.ON_ACTION_END)
