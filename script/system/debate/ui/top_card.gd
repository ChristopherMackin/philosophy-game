@tool
extends Node

class_name TopCard

@export var cost : Node
@export var icon : Node
@export var title : Node
@export var artwork : Node
@export var description : Node
@export var colorable_elements : Array[Node]

@export var top : TopData:
	set(val):
		top = val
		update_card.call_deferred(top)

func update_card(top : TopData) :
		if !top:
			return
		
		cost.text = str(top.cost)
		icon.texture = top.pose.icon
		title.text = top.title.to_upper()
		description.text = top.description
		artwork.texture = top.artwork
		
		for e in colorable_elements:
			if "self_modulate" in e:
				e.self_modulate = top.pose.color
			else:
				e.modulate = top.pose.color
