extends Resource

class_name EventManager

signal on_event_finished

var subscriber_array : Array[EventSubscriber]
var current_event : Event
var current_task : Task

func subscribe(subscriber : EventSubscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func start_event(event : Event):
	if !event || (current_event && !event.is_major_event): return
	
	current_event = event
	current_task = event.start_task
	current_task.invoke.call_deferred(self)
	current_task.action.on_action_complete.connect(start_next_task)

func start_next_task(next_task_index):
	if next_task_index == -1:
		current_task = null
		current_event = null
		on_event_finished.emit()

func display_dialogue(text : String, actor : String):
	for sub : EventSubscriber in subscriber_array: await sub.display_dialogue(text, actor)

func play_animation(name : String, actor : String, await_animation : bool):
	for sub : EventSubscriber in subscriber_array: await sub.play_animation(name, actor, await_animation)
