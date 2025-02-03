@tool
extends Control

class_name TopsCardUI

@export var cost : Node
@export var icon : Node
@export var title : Node
@export var artwork : Node
@export var description : Node

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
		title.text = top.data.title
		description.text = top.data.description
		artwork.texture = top.data.artwork
