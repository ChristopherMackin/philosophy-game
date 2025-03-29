extends CardCollectionContainer

class_name ContestantHandCollectionContainer

@export var which_contestant : Const.WhichContestant
var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func _get_unfiltered_collection() -> Array[Card]:
	return contestant.hand.get_cards()

func add_card_to_collection(card: Card):
	await contestant.hand.push_back(card)
