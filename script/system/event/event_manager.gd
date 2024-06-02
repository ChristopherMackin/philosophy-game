extends Resource

class_name EventManager

var subscriber_array : Array[EventSubscriber]

func subscribe(subscriber : EventSubscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func play_event_tree(event_tree : EventTree):
	var current_event := event_tree.start_event
	
	while current_event:
		var index = await current_event.invoke(self)
		current_event = event_tree.get_event(index)

func display_dialogue(text : String):
	for sub : EventSubscriber in subscriber_array: await sub.display_dialogue(text)

func play_animation(name : String, actor : String, await_animation : bool):
	for sub : EventSubscriber in subscriber_array: await sub.play_animation(name, actor, await_animation)
