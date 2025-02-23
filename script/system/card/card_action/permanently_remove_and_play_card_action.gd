extends CardAction

class_name PermanentlyRemoveAndPlayCardAction

@export var suit_filters : Array[Suit]

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var ac = player
	var iac = manager.get_opponent(player)
	
	var cards : Array = iac.hand.filter(func(x : Card): return suit_filters.has(x.suit))
	if cards.size() <= 0:
		return
	
	var selected_card = await ac.select(cards, "permanent_removal")
	
	iac.remove_card_from_hand(selected_card)
	iac.deck.remove_from_deck(selected_card)
	
	await ac.play_card_cost_override(selected_card)
