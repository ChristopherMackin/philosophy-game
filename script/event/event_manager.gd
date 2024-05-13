extends Node2D

class_name EventManager

func _ready():
	var event = ConsoleLogEvent.new()
	event.console_text = "TEST"
	var event_2 = ConsoleLogEvent.new()
	event_2.console_text = "DONE"
	
	event.next_event = event_2
	
	var event_tree = EventTree.new()
	event_tree.start_event = event
	
	play_event_tree(event_tree)

func play_event_tree(event_tree : EventTree):
	var current_event := event_tree.start_event
	
	while current_event:
		current_event = current_event.invoke(self)
