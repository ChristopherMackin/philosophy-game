extends CardAction

class_name RemoveSelectedCardsCardAction

@export var which_contestant: Const.WhichContestant
@export var card_collection: Const.CardCollection
@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	var selected_cards = manager.blackboard.get_value("action.%s" % key)
	
	if selected_cards == null || selected_cards.size() <= 0: return true
	
	var method := func(): pass
	
	match card_collection:
		Const.CardCollection.HAND:
			method = contestant.remove_from_hand
		Const.CardCollection.DISCARD:
			method = contestant.remove_from_discard
		Const.CardCollection.DRAW_PILE:
			method = contestant.remove_from_draw_pile
		Const.CardCollection.DECK:
			method = contestant.remove_from_deck
		Const.CardCollection.PLAY_STACK:
			method = manager.remove_from_playstack
		Const.CardCollection.HOLD:
			method = func(card: Card): 
				if contestant.held_card == card:
					contestant.held_card = null
					if card != null:
						card.on_hold_end(contestant, manager)
	
	for selected_card in selected_cards:
		await method.call(selected_card)
	
	return true
