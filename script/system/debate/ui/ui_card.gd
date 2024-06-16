extends Sprite2D

class_name UICard

var mouse_over : bool

var enabled : bool = true:
	get: return enabled
	set(val):
		enabled = val
		get_node("Touch").visible = enabled
		
		if enabled:
			modulate = Color.WHITE
		else:
			mouse_exited()
			modulate = Color.DARK_GRAY

var card : Card
var on_click : Callable = func(): print ("UNIMPLEMENTED")
var color : Color = Color.BLACK:
	get:
		return color
	set(val):
		color = val
		pose_icon_1.modulate = color
		pose_icon_2.modulate = color
		border.modulate = color

var border : Sprite2D
var pose_icon_1 : Sprite2D
var pose_icon_2 : Sprite2D
var card_action_icon : Sprite2D

enum Sign {
	POSITIVE,
	NEGATIVE,
	NONE
}

var sign : Sign:
	get:
		return sign
	set(val):
		sign = val
		card_action_icon.self_modulate = Color.WHITE
		
		match sign:
			Sign.POSITIVE:
				card_action_icon.texture = card.data.action.positive_icon
			Sign.NEGATIVE:
				card_action_icon.texture = card.data.action.negative_icon
			_:
				card_action_icon.texture = card.data.action.positive_icon
				card_action_icon.self_modulate = Color(.5, .5, .5, .5)

func initialize(card : Card, on_click : Callable = func(): pass):
	border = get_node("Border")
	pose_icon_1 = get_node("PoseIcon1")
	pose_icon_2 = get_node("PoseIcon2")
	card_action_icon = get_node("CardActionIcon")
	
	self.card = card
	pose_icon_1.texture = card.data.pose.icon
	pose_icon_2.texture = card.data.pose.icon
	card_action_icon.texture = card.data.action.positive_icon
	color = card.data.pose.color
	
	self.on_click = on_click

func mouse_entered():
	z_index = 1
	scale = Vector2.ONE * 1.1
	mouse_over = true

func mouse_exited():
	z_index = 0
	scale = Vector2.ONE
	mouse_over = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if mouse_over == true:
					on_click.call()

func remove_interaction():
	mouse_exited()
	modulate = Color.WHITE
	set_script(null)
