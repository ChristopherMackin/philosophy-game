extends CardCollection

class_name ContestantHand

@export var which_contestant : Const.WhichContestant
var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func get_card_collection() -> Array[Card]:
	return contestant.hand.duplicate()

func remove_card_from_collection(card: Card):
	contestant.remove_from_hand(card)

func add_card_to_collection(card: Card):
	contestant.add_to_hand(card)
