extends NinePatchRect

class_name CurrentCardUI

var color : Color = Color.BLACK:
	get:
		return color
	set(val):
		color = val
		icon.modulate = color
		border.modulate = color

var icon : TextureRect
var border : NinePatchRect

func update_card(card : Card):
	icon = get_node("Icon")
	border = get_node("Border")
	
	icon.texture = card.data.pose.icon
	color = card.data.pose.color
