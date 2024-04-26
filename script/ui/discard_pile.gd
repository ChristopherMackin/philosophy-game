extends Node2D

class_name DiscardPile

func discard(ui_card : UICard):
	ui_card.remove_interaction()
	Help.set_parent(ui_card, self)
	Help.lerp_to_position(ui_card, Vector2.ZERO, .2)
