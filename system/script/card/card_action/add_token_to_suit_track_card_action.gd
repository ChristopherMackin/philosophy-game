extends CardAction

class_name AddTokenToSuitTrackCardAction

@export var suit : Suit
@export var amount : int = 1
@export var token_data : TokenData

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	suit = suit if suit else caller.suit
	var token_array: Array[Token]
	
	for i in amount:
		token_array.append(Token.new(token_data))
		
	await manager.add_tokens_to_suit_track(token_array, suit)
	
	return true
