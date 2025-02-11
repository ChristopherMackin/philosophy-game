@tool
extends Control

class_name CardUI

@export var cost : Node
@export var icon : Node
@export var title : Node
@export var artwork : Node
@export var description : Node

var card : Card:
	set(val):
		card = val
		update_card.call_deferred(card)

func _process(delta):
	if !card:
			return
		
	cost.text = str(card.cost)

func update_card(card : Card) :
		if !card:
			return
		
		cost.text = str(card.cost)
		icon.texture = card.data.suit.icon
		title.text = card.data.title
		description.text = card.data.description
		artwork.texture = card.data.token_data.artwork
