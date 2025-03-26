extends CardCollection

class_name ContestantDrawPile

@export var which_contestant : Const.WhichContestant
@export var amount = -1
@export_enum("Beginning", "End") var starting_point := 0
@export_enum("Beginning", "End", "Random") var insertion_point := 0

var contestant: Contestant:
	get(): return Const.GetContestant(player, manager.get_opponent(player), which_contestant)

func get_card_collection() -> Array[Card]:
	var draw_pile = contestant.draw_pile
	var card_array = []
	
	if amount == -1: card_array = draw_pile
	else:
		var amount = self.amount if self.amount <= draw_pile.size() else draw_pile.size()
		
		if starting_point == 0:
			card_array = draw_pile.slice(0, amount)
		else:
			card_array = draw_pile.slice(0, -(amount), -1)
	
	for card: Card in card_array:
		card.generate_token()
	
	return card_array

func remove_card_from_collection(card: Card) -> bool:
	return contestant.remove_from_draw_pile(card)

func add_card_to_collection(card: Card) -> bool:
	card.destroy_token()
	
	match  insertion_point:
		0:
			contestant.push_front_to_draw_pile(card)
		1:
			contestant.append_to_draw_pile(card)
		2:
			contestant.random_insert_to_draw_pile(card)
	
	return true
