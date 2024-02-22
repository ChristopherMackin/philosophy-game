extends Sprite2D

class_name WorldspaceDebateUI

@export var card_sprite : Sprite2D

func update_card(card : Card):
	card_sprite.modulate = card.data.suit.color
