extends CardCollectionContainer

class_name HoldCollectionContainer

@export var which_contestant : Const.WhichContestant
var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func _get_unfiltered_collection() -> Array[Card]:
	if contestant.held_card:
		return contestant.held_card.get_cards()
	else:
		return []

func add_card_to_collection(card: Card):
	contestant.hold_card(card)
