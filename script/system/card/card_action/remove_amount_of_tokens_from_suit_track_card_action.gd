extends CardAction

class_name RemoveAmountOfTokensFromSuitTrackCardAction

@export var suit : Suit
@export var amount : int = 1

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	suit = suit if suit else caller.suit
	
	for i in amount:
		await manager.pop_from_suit_track(suit)
	
	return true
