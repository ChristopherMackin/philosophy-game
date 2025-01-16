extends Node3D

class_name TopsCard3D

@export var tops_card_ui : TopsCardUI
@export var sub_viewport : SubViewport

func set_top(top : Top):
	tops_card_ui.top = top
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE 
