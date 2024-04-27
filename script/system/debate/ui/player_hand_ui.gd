@tool
extends Node2D

class_name PlayerHandUI

@export var player_brain : PlayerBrain

@export var debate_settings : DebateSettings

@export var card_container : Node2D
@export var discard_pile : DiscardPileUI

var ui_card_array : Array = []

@export var card_prefab : PackedScene

@export var enabled : bool = false:
	get: return enabled
	set(val):
		enabled = val
		
		for child in card_container.get_children():
			child.enabled = val

func on_card_played(card : Card):
	var cards = ui_card_array.map(func(x): return x.card)
	var index = cards.find(card)
	
	if index == -1:
		return
	
	var ui_card = ui_card_array.pop_at(index)
	await discard_pile.discard(ui_card)

func add_cards(added_cards : Array):
	for card in added_cards:
		var ui_card : UICard = card_prefab.instantiate()
		
		var index : int = ui_card_array.size()
		
		var on_click : Callable
		if player_brain:
			on_click = func() :
				player_brain.play_card(card)
		
		ui_card.initialize(card, on_click)
		ui_card.enabled = enabled
		
		ui_card_array.append(ui_card)
		
		card_container.add_child(ui_card)

func update_card_array(hand_card_array : Array, current_suit: Suit):
	var to_add_array = hand_card_array.duplicate();
	
	for ui_card : UICard in ui_card_array.duplicate():
		var index = hand_card_array.find(ui_card.card)
		
		if index == -1:
			var i = ui_card_array.find(ui_card)
			ui_card_array.pop_at(i).queue_free()
		else:
			var card = hand_card_array[index]
			var i = to_add_array.find(card)
			to_add_array.remove_at(i)
	
	add_cards(to_add_array)
	Util.sort_children(card_container, func(a: UICard, b: UICard): return a.card.data.suit.name.naturalnocasecmp_to(b.card.data.suit.name) < 0)
	
	for ui_card : UICard in ui_card_array:
		var relation = debate_settings.get_suit_relationship(current_suit, ui_card.card.data.suit)
		
		match relation:
			DebateSettings.SuitRelationship.SAME:
				ui_card.sign = UICard.Sign.POSITIVE
			DebateSettings.SuitRelationship.OPPOSING:
				ui_card.sign = UICard.Sign.NEGATIVE
			_:
				ui_card.sign = UICard.Sign.NONE
