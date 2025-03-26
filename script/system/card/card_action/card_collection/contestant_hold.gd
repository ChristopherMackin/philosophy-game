extends CardCollection

class_name ContestantHold

@export var which_contestant : Const.WhichContestant
var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func get_card_collection() -> Array[Card]:
	if contestant.held_card:
		return [contestant.held_card]
	else:
		return []

func remove_card_from_collection(card: Card):
	contestant.remove_held_card()

func add_card_to_collection(card: Card):
	contestant.hold_card(card)
