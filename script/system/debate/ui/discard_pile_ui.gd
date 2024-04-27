extends Node2D

class_name DiscardPileUI

func discard(ui_card : UICard):
	ui_card.remove_interaction()
	Util.set_parent(ui_card, self)
	await Util.lerp_to_position(ui_card, Vector2.ZERO, .2)
