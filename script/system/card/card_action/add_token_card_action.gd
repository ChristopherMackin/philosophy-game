extends CardAction

class_name AddTokenCardAction

@export var amount : int = 1
@export var token_data : TokenData

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		var token = Token.new(token_data)
		await manager.add_token_to_suit_track(token, card.suit)
