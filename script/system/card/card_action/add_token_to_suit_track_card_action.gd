extends CardAction

class_name AddTokenToSuitTrackCardAction

@export var suit : Suit
@export var amount : int = 1
@export var token_data : TokenData

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	suit = suit if suit else caller.suit
	
	for i in amount:
		var token = Token.new(token_data)
		await manager.add_token_to_suit_track(token, suit)
