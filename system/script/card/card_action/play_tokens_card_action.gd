extends CardAction

class_name PlayTokensCardAction

@export var suit : Suit
@export var token_counter : int = 1
@export var token_data : TokenData

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	suit = suit if suit else caller.suit
		
	await manager.play_tokens(token_data, token_counter, suit, player)
	
	return true
