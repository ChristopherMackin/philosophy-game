@tool
extends CardAction

class_name PlayTokensFromCardCollectionCardAction

@export var card_collection: CardCollectionContainer
@export_enum("Suit", "Blackboard Suits", "Caller Suit") var suit_selection_mode : int = 0:
	set(val):
		suit_selection_mode = val
		notify_property_list_changed()

@export var suit : Suit
@export var key : String = "action_suits"

func _validate_property(property: Dictionary):
		if property.name == "suit" and suit_selection_mode != 0:
			property.usage = PROPERTY_USAGE_NO_EDITOR
		if property.name == "key" and suit_selection_mode != 1:
			property.usage = PROPERTY_USAGE_NO_EDITOR

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_collection_cards()
	
	match suit_selection_mode:
		0:
			for card in cards:
				if !card.has_token: continue
				manager.play_token(card.pop_token(), suit, player)
		1:
			var suit = manager.blackboard.get_value(key)[0]
			for card in cards:
				if !card.has_token: continue
				manager.play_token(card.pop_token(), suit, player)
		2:
			for card in cards:
				if !card.has_token: continue
				manager.play_token(card.pop_token(), card.suit, player)
