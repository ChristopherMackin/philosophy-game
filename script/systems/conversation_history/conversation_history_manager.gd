extends Node2D

class_name ConversationHistoryManager

@export var conversation_bubble_prefab : PackedScene

@export var margin : float

var queue : Queue = Queue.new()

signal animation_finished

func add_card(card : Card, dir : DebateBubble.TalkDirection):
	var bubble : DebateBubble = conversation_bubble_prefab.instantiate()
	bubble.initialize(card, dir)
	add_child(bubble)
	
	var tex_height = bubble.texture.get_height()
	bubble.position += Vector2(0, tex_height + margin)
	queue.push(bubble)
	
	for obj : DebateBubble in queue.array:
		obj.move(Vector2(0, -(tex_height + margin)))
	
	await bubble.animation_finished
	animation_finished.emit()
