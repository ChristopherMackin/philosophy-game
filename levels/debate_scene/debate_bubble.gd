extends Sprite2D

class_name DebateBubble

@export var card_sprite : Sprite2D
@export var speach_bubble_direction : Sprite2D

var start_pos : Vector2
var end_pos : Vector2

var timer : float
@export var duration : float = .5

signal animation_finished

enum TalkDirection{
	LEFT,
	RIGHT,
}

func _process(delta):
	if timer <= 0:
		return
	
	timer -= delta
	
	if timer <= 0:
		position = end_pos
		animation_finished.emit()
	else:
		position = start_pos.slerp(end_pos, 1 - timer/duration)

func initialize(card : Card, dir : TalkDirection):
	#Eventually set image and color here
	card_sprite.modulate = card.data.suit.color
	if dir == TalkDirection.LEFT:
		var pos = speach_bubble_direction.position
		pos.x = -pos.x
		speach_bubble_direction.position = pos
		
		var sca = speach_bubble_direction.scale
		sca.x = -sca.x
		speach_bubble_direction.scale = sca

func move(amount : Vector2):
	if not end_pos:
		end_pos = position
		
	start_pos = position
	end_pos = end_pos + amount
	timer = duration
