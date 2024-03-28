@tool
extends Node2D

class_name HandUI

@export var player_brain : PlayerBrain

@export var debate_settings : DebateSettings

@export var card_container : Node2D
@export var discard_pile : DiscardPile

var ui_card_array : Array = []

@export var card_prefab : PackedScene

signal animation_finished

func is_enabled(val : bool):
	for child in get_children():
		child.set_process(val)

func on_card_played(card : Card):
	var cards = ui_card_array.map(func(x): return x.card)
	var index = cards.find(card)
	
	if index == -1:
		return
	
	var ui_card = ui_card_array.pop_at(index)
	discard_pile.discard(ui_card)

func add_cards(added_cards : Array):
	for card in added_cards:
		var ui_card : UICard = card_prefab.instantiate()
		
		var index : int = ui_card_array.size()
		var on_click : Callable = func() :
			player_brain.play_card(card)
		
		ui_card.initialize(card, on_click)
		
		ui_card_array.append(ui_card)
		
		card_container.add_child(ui_card)

func update_card_array(hand_card_array : Array):
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
	Help.sort_children(card_container, func(a: UICard, b: UICard): return a.card.data.suit.name.naturalnocasecmp_to(b.card.data.suit.name) < 0)
