extends Node2D

@export var player_brain : PlayerBrain
@export var card_container : Node
var ui_card_array : Array = []

@export var card_prefab : PackedScene

func on_card_played(card : Card):
	var cards = ui_card_array.map(func(x): return x.card)
	var index = cards.find(card)
	var element = ui_card_array.pop_at(index)
	element.queue_free()


func on_cards_drawn(added_cards : Array):
	for card in added_cards:
		var ui_card : UICard = card_prefab.instantiate()
		
		var index : int = ui_card_array.size()
		var on_click : Callable = func() : player_brain.play_card(card)
		
		ui_card.initialize(card, on_click)
		
		ui_card_array.append(ui_card)
		card_container.add_child(ui_card)

func update_card_array(hand_card_array : Array):
	pass
