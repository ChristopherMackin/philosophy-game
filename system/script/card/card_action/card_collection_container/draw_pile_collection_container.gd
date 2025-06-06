extends CardCollectionContainer

class_name DrawPileCollectionContainer

@export var which_contestant : Const.WhichContestant
@export_enum("Beginning", "End", "Random") var insertion_point := 0

var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func _get_unfiltered_collection() -> Array[Card]:
	return contestant.draw_pile.get_cards()

func add_card_to_collection(card: Card):	
	match  insertion_point:
		0:
			contestant.draw_pile.push_front(card)
		1:
			contestant.draw_pile.push_back(card)
		2:
			contestant.draw_pile.insert_random(card)
