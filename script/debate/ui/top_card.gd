@tool
extends Node

class_name TopCard

@export var cost : Node
@export var icon : Node
@export var title : Node
@export var artwork : Node
@export var description : Node
@export var colorable_elements : Array[Node]

var top : Top:
	set(val):
		top = val
		update_card.call_deferred(top)

func _process(delta):
	if !top:
			return
		
	cost.text = str(top.data.cost)

func update_card(top : Top) :
		if !top:
			return
		
		cost.text = str(top.data.cost)
		icon.texture = top.data.pose.icon
		title.text = top.data.title.to_upper()
		description.text = top.data.description
		artwork.texture = top.data.artwork
		
		for e in colorable_elements:
			if "self_modulate" in e:
				e.self_modulate = top.data.pose.color
			else:
				e.modulate = top.data.pose.color

