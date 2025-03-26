@tool
extends CardAction

class_name AddCardToCardCollectionCardAction

@export var which_contestant : Const.WhichContestant
@export var card_collection := Const.CardCollection.HAND:
	set(val):
		card_collection = val
		notify_property_list_changed()

@export_enum("Random", "Beginning", "End") var insertion_point : int = 0

@export var base : CardBase
@export var amount : int = 1

func _validate_property(property: Dictionary):
	if property.name == "insertion_point" and card_collection != Const.CardCollection.DRAW_PILE:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	var function = func(card: Card): pass
	
	match card_collection:
		Const.CardCollection.HAND:
			function = contestant.add_to_hand
		Const.CardCollection.DRAW_PILE:
			match insertion_point:
				0: function = contestant.draw_pile_random_insert
				1: function = contestant.draw_pile_push_front
				2: function = contestant.draw_pile_append
		Const.CardCollection.DECK:
			function = contestant.add_to_deck
		Const.CardCollection.DISCARD:
			function = contestant.discard_card
		Const.CardCollection.PLAY_STACK:
			function = manager.play_stack.append
	
	for i in amount:
		function.call(Card.new(base, manager))
