@tool
extends Node2D

class_name ComputerHandUI

@export var card_prefab : PackedScene
@export var discard : DiscardPile

func on_card_played(card : Card):
	var ui_card : UICard = card_prefab.instantiate()
	ui_card.initialize(card)
	add_child(ui_card)
	
	discard.discard(ui_card)
