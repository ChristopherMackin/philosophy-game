@tool
extends Control

class_name CardUi

@export var card_bg : Node
@export var title : Node
@export var artwork : Node
@export var shadow : Node
@export var description : Node
@export var cost : Node
@export var icon : Node

var card : Card:
	set(val):
		card = val
		refresh_card.call_deferred()

func _process(_delta):
	if !card:
			return
		
	if cost: cost.text = str(card.cost)

func refresh_card():
		if !card:
			return
		
		if card_bg : card_bg.self_modulate = card.base.suit.color;
		if cost: cost.text = str(card.cost)
		if icon: icon.texture = card.suit.icon
		if title: title.text = card.title
		if description: description.text = card.description
		if artwork: 
			artwork.texture = card.token_artwork
			shadow.visible = !artwork.texture == null

func animate_hold():
	queue_free()

func animate_play():
	queue_free()
