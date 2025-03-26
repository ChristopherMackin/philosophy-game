extends CardAction

class_name AddSelectedCardsToCardCollectionCardAction

@export var which_contestant: Const.WhichContestant
@export var card_collection: Const.CardCollection
@export var key : String = "selection"

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	var selected_cards = manager.blackboard.get_value("action.%s" % key)
	
	var method := func(): pass
	
	match card_collection:
		Const.CardCollection.HAND:
			method = contestant.add_to_hand
		Const.CardCollection.DISCARD:
			method = contestant.discard_card
		Const.CardCollection.DRAW_PILE:
			method = contestant.append_to_draw_pile
		Const.CardCollection.DECK:
			method = contestant.add_to_deck
		Const.CardCollection.PLAY_STACK:
			method = func(card: Card): manager.play_stack.append(card)
		Const.CardCollection.HOLD: 
			method = func(card: Card):
				contestant.hold_card(card, false)
	
	for selected_card in selected_cards:
		await method.call(selected_card)
	
	return true
