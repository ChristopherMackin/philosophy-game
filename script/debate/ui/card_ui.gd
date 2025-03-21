@tool
extends Control

class_name CardUI

@export var title : Node
@export var artwork : Node
@export var description : Node
@export var cost : Node
@export var icon : Node

var card : Card:
	set(val):
		card = val
		update_card.call_deferred(card)

func _process(delta):
	if !card:
			return
		
	if cost: cost.text = str(card.cost)

func update_card(card : Card) :
		if !card:
			return
		
		if cost: cost.text = str(card.cost)
		if icon: icon.texture = card.suit.icon
		if title: title.text = card.title
		if description: description.text = card.description
		if artwork: artwork.texture = card.token_artwork
