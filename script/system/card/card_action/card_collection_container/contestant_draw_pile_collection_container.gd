extends CardCollectionContainer

class_name ContestantDrawPileCollectionContainer

@export var which_contestant : Const.WhichContestant
@export var amount = -1
@export_enum("Beginning", "End") var starting_point := 0
@export_enum("Beginning", "End", "Random") var insertion_point := 0

var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func get_collection_cards() -> Array[Card]:
	var draw_pile = contestant.draw_pile
	var card_array = []
	
	if amount == -1: card_array = draw_pile.get_cards()
	else:
		var amount = self.amount if self.amount <= draw_pile.size() else draw_pile.size()
		
		if starting_point == 0:
			card_array = draw_pile.slice(0, amount)
		else:
			card_array = draw_pile.slice(0, -(amount), -1)
	
	for card: Card in card_array:
		card.generate_token()
	
	return card_array

func add_card_to_collection(card: Card):	
	match  insertion_point:
		0:
			contestant.draw_pile.push_front(card)
		1:
			contestant.draw_pile.push_back(card)
		2:
			contestant.draw_pile.insert_random(card)
