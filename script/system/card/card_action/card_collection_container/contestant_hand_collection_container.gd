extends CardCollectionContainer

class_name ContestantHandCollectionContainer

@export var which_contestant : Const.WhichContestant
var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func get_collection_cards() -> Array[Card]:
	return contestant.hand.get_cards()

func remove_card_from_collection(card: Card) -> bool:
	return contestant.remove_from_hand(card)

func add_card_to_collection(card: Card) -> bool:
	return contestant.add_to_hand(card)
