@tool
extends Control

class_name CardUi

@export var card_bg : Node
@export var title : Node
@export var artwork: Node
@export var token_artwork: Node
@export var token_counter: Node
@export var description : Node
@export var cost : Node
@export var icon : Node

var card : Card:
	set(val):
		Util.optional_disconnect(card, "card_updated", refresh_card)
		card = val
		Util.optional_connect(card, "card_updated", refresh_card, CONNECT_DEFERRED)
		refresh_card.call_deferred(card)

func refresh_card(card: Card):
		if !card:
			return
		
		if card_bg : card_bg.self_modulate = card.suit.color;
		if cost: cost.text = str(card.cost)
		if icon: icon.texture = card.suit.icon
		if title: title.text = card.title
		if description: description.text = card.description
		if artwork: pass
		if token_artwork: 
			token_artwork.visible = true
			token_artwork.texture = card.token_artwork
		else:
			token_artwork.visible = false
		if token_counter: token_counter.text = str(card.token_counter)

func animate_hold():
	queue_free()

func animate_play():
	queue_free()
