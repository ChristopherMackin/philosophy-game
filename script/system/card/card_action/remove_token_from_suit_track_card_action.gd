extends CardAction

class_name RemoveTokenFromSuitTrackCardAction

@export var suit : Suit
@export var amount : int = 1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	suit = suit if suit else card.suit
	
	for i in amount:
		await manager.pop_from_suit_track(suit)
