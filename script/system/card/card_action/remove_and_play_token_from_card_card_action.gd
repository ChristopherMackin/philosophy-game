extends CardAction

class_name RemoveAndPlayTokenFromCardCardAction

@export var which_contestant : Const.WhichContestant
@export var suit: Suit
@export var card_filter : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var response = await player.select(SelectionRequest.new(
		selectable_cards,
		"remove_and_play_token_from_card",
		which_contestant
	))
	
	var token: Token = response.data.pop_token()
	if token:
		manager.play_token(token, suit, player)
