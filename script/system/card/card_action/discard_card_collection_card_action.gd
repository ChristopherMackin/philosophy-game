extends CardAction

class_name DiscardCardCollectionContainerCardAction

@export var collection_container : CardCollectionContainer
@export var which_contestant : Const.WhichContestant

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	collection_container.init(caller, player, manager)
	var cards = await collection_container.get_collection_cards()
		
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	for card in cards:
		await contestant.discard_pile.push_front(card)
	
	manager.blackboard.add("action.discarded_cards", cards, Const.ExpirationToken.ON_ACTION_END)
