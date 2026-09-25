@tool
extends Control

class_name CardUi

@export_group("Dependencies")
@export var card_bg : Node
@export var title : Node
@export var artwork: Node
@export var token_artwork: Node
@export var token_counter: RichTextLableUpdateEmitter
@export var description : Node
@export var cost : RichTextLableUpdateEmitter
@export var icon : Node
@export var card_animations: CardUiAnimation

var packed_scene_name: String

var dirty = false

func _on_card_updated(card: Card):
	dirty = true

signal card_ui_updated

var card : Card:
	set(val):
		Util.optional_disconnect(card, "card_updated", _on_card_updated)
		card = val
		Util.optional_connect(card, "card_updated", _on_card_updated, CONNECT_DEFERRED)
		set_card_data(card)

func update_card(card: Card):
	if !dirty: return
	dirty = false
	set_card_data(card)
	animate_updated()
	card_ui_updated.emit()

func set_card_data(card: Card):
		if !card:
			return
		
		if card_bg : card_bg.self_modulate = card.suit.color;
		if cost: cost.update_label(str(card.cost))
		if icon: icon.texture = card.suit.icon
		if title: title.text = card.title
		if description: description.text = card.description
		if artwork: pass
		if token_artwork: 
			token_artwork.visible = true
			token_artwork.texture = card.token_artwork
		else:
			token_artwork.visible = false
		if token_counter: token_counter.update_label(str(card.token_counter))

func animate_updated():
	await card_animations.on_card_updated()

func animate_hold():
	await card_animations.on_card_held()

func animate_play():
	await card_animations.on_card_played()

func animate_remove():
	await card_animations.on_card_removed()
