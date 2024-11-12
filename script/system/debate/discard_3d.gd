extends Node3D

class_name Discard3D

var top_cards_3d : Array[TopCard]
@export var per_card_offset : Vector3

func discard_card(top_card : TopCard, duration : float = 1):
	get_tree().create_tween().tween_property(top_card, "global_position", global_position + per_card_offset * top_cards_3d.size(), duration)
	add_child(top_card)
	top_cards_3d.append(top_card)
