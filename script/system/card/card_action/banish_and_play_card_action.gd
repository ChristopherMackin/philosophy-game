extends CardAction

class_name BanishAndPlayCardAction

@export var which_contestant : Const.WhichContestant
@export var card_filters : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	var cards : Array = contestant.hand.filter(func(x : Card): return card_filters.has(x.suit))
	if cards.size() <= 0:
		return
	
	var response = await player.select(SelectionRequest.new(
		cards, 
		"permanently_remove_and_play",
		which_contestant
	))
	
	var card_to_remove = response.data
	
	contestant.remove_from_hand(card_to_remove)
	contestant.remove_from_deck(card_to_remove)
	
	await manager.play_token(card_to_remove.pop_token(), card_to_remove.suit, player)
	await manager.play_card(card_to_remove, player)
