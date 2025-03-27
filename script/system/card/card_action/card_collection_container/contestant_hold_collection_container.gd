extends CardCollectionContainer

class_name ContestantHoldCollectionContainer

@export var which_contestant : Const.WhichContestant
var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func get_collection_cards() -> Array[Card]:
	if contestant.held_card:
		return contestant.held_card.get_cards()
	else:
		return []

func remove_card_from_collection(card: Card):
	contestant.remove_held_card()

func add_card_to_collection(card: Card):
	contestant.hold_card(card)
