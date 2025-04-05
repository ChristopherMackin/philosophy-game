extends Node3D

class_name PlayStack3D

var cards_3d : Array[Card3D]
@export var per_card_offset : Vector3

func add_card_to_playstack(card : Card3D, duration : float = 1):
	get_tree().create_tween().tween_property(card, "global_position", global_position + per_card_offset * cards_3d.size(), duration)
	add_child(card)
	cards_3d.append(card)
