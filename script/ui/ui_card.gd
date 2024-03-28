extends Sprite2D

class_name UICard

var mouse_over : bool
var interactable : bool = false

var card : Card
var on_click : Callable = func(): print ("UNIMPLEMENTED")
var color : Color = Color.BLACK:
	get:
		return color
	set(val):
		color = val
		icon.modulate = color
		border.modulate = color

var icon : Sprite2D
var border : Sprite2D

func initialize(card : Card, on_click : Callable):
	icon = get_node("Icon")
	border = get_node("Border")
	
	self.card = card
	icon.texture = card.data.suit.icon
	color = card.data.suit.color
	
	self.on_click = on_click

func mouse_entered():
	if !interactable:
		return;
	
	z_index = 1
	scale = Vector2.ONE * 1.1
	mouse_over = true

func mouse_exited():
	if !interactable:
		return;
	
	z_index = 0
	scale = Vector2.ONE
	mouse_over = false

func _input(event):
	if !interactable:
		return;
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if mouse_over == true:
					on_click.call()

