extends Resource

class_name EventManager

var subscriber_array : Array[EventSubscriber]

func subscribe(subscriber : EventSubscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func play_event(event : Event):
	if !event:
		return
	
	var current_task := event.start_task
	
	while current_task:
		var index = await current_task.invoke(self)
		current_task = event.get_task(index)

func display_dialogue(text : String, actor : String, await_input : bool):
	for sub : EventSubscriber in subscriber_array: await sub.display_dialogue(text, actor, await_input)

func play_animation(name : String, actor : String, await_animation : bool):
	for sub : EventSubscriber in subscriber_array: await sub.play_animation(name, actor, await_animation)
