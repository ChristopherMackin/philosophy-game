extends CardAction

class_name FillOptionsWithCardCollectionCardAction

@export var which_contestant: Const.WhichContestant
@export var card_collection: Const.CardCollection
@export var pull_from_end: bool
@export var amount: int = -1

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	var card_array : Array[Card] = []
	
	match card_collection:
		Const.CardCollection.HAND:
			card_array = format_array(contestant.hand)
		Const.CardCollection.DISCARD:
			card_array = format_array(contestant.discard_pile)
		Const.CardCollection.DRAW_PILE:
			card_array = format_array(contestant.draw_pile)
		Const.CardCollection.DECK:
			card_array = format_array(contestant._deck)
		Const.CardCollection.PLAY_STACK:
			card_array = format_array(manager.play_stack)
		Const.CardCollection.HOLD:
			if contestant.held_card:
				card_array = [contestant.held_card]
		Const.CardCollection.SELF:
			card_array = [card]
	
	manager.blackboard.add("action.options", card_array, Const.ExpirationToken.ON_ACTION_END)
	manager.blackboard.add("action.type", Const.SelectionType.CARD, Const.ExpirationToken.ON_ACTION_END)
	
	return true

func format_array(array: Array[Card]) -> Array[Card]:
	if amount == -1 || amount > array.size(): return array
	elif pull_from_end:
		return array.slice(0, -(amount - 1), -1)
	else:
		return array.slice(0, amount - 1)
