extends CardCollectionContainer

class_name DiscardCollectionContainer

@export var which_contestant : Const.WhichContestant

var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func _get_unfiltered_collection() -> Array[Card]:
	return contestant.discard_pile.get_cards()

func add_card_to_collection(card: Card):
	await contestant.discard_pile.push_front(card)
