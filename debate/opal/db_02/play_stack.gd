extends Node

class_name PlayStack

@export var offset: Vector3
@export var card_ui_factory_base: CardUiFactoryBase
@export var card_3d: PackedScene

var cards_3d: Array[Card3d] = []

func add_card_to_play_stack(card):
	var instance: Card3d = card_3d.instantiate()
	add_child(instance)
	var cgps = card_ui_factory_base.get_card_ui(card)
	instance.init(card, cgps)
	instance.position += offset * cards_3d.size()
	cards_3d.append(instance)
