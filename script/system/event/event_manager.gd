extends Resource

class_name EventManager

var subscriber_array : Array[EventSubscriber]
var current_task : Task

func subscribe(subscriber : EventSubscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func start_event(event : Event):
	if !event || (current_task && !event.is_major_event): return
	
	if current_task:
		current_task.cancel(self)
		
	current_task = event.start_task
	
	while current_task:
		var index = await current_task.invoke(self)
		current_task = event.get_task(index)

func display_dialogue(text : String, actor : String):
	for sub : EventSubscriber in subscriber_array: await sub.display_dialogue(text, actor)

func cancel_dialogue(actor : String):
		for sub : EventSubscriber in subscriber_array: await sub.cancel_dialogue(actor)

func play_animation(name : String, actor : String, await_animation : bool):
	for sub : EventSubscriber in subscriber_array: await sub.play_animation(name, actor, await_animation)

func cancel_animation(actor : String):
	for sub : EventSubscriber in subscriber_array: await sub.cancel_animation(actor)
