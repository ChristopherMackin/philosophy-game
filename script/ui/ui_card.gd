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
		icon.modulate = color
		border.modulate = color

var icon : Sprite2D
var border : Sprite2D

func initialize(card : Card, on_click : Callable = func(): pass):
	icon = get_node("Icon")
	border = get_node("Border")
	
	self.card = card
	icon.texture = card.data.suit.icon
	color = card.data.suit.color
	
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
