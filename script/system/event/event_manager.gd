extends Node2D

class_name EventManager

@export var event_tree : EventTree

func _ready(): 
	play_event_tree(event_tree)

func play_event_tree(event_tree : EventTree):
	var current_event := event_tree.start_event
	
	while current_event:
		current_event = current_event.invoke(self)
