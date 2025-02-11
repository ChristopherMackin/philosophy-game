extends Node3D

class_name Card3D

@export var card_ui : CardUI
@export var sub_viewport : SubViewport

func set_card(card : Card):
	card_ui.card = card
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE 
