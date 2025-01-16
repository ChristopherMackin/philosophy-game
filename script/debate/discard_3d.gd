extends Node3D

class_name Discard3D

var tops_cards_3d : Array[TopsCard3D]
@export var per_card_offset : Vector3

func discard_card(tops_card : TopsCard3D, duration : float = 1):
	get_tree().create_tween().tween_property(tops_card, "global_position", global_position + per_card_offset * tops_cards_3d.size(), duration)
	add_child(tops_card)
	tops_cards_3d.append(tops_card)
