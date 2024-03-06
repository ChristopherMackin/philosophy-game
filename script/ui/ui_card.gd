extends Sprite2D

class_name UICard

var mouse_over : bool
var card : Card
var on_click : Callable = func(): print ("UNIMPLEMENTED")

func initialize(card : Card, on_click : Callable):
	self.card = card
	self.modulate = card.data.suit.color
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

