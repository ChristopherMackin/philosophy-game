extends Resource

class_name EventManager

var subscribers : Array[EventSubscriber]
var current_task : Task

@export var blackboard : Blackboard

func subscribe(subscriber : EventSubscriber):
	subscribers.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscribers.find(subscriber)
	
	if index != -1:
		subscribers.remove_at(index)

func start_event(event : Event):
	if !event || (current_task && !event.is_major_event): return
	
	if current_task:
		current_task.cancel(self)
		
	current_task = event.start_task
	
	while current_task:
		var index = await current_task.invoke(self)
		current_task = event.get_task(index)
	
	var expire = event.get_expiration_token()
	if expire != null:
		blackboard.add(event.resource_path.get_file(), true, expire)

func display_dialogue(text : String, actor : String, await_input : bool, seconds_before_close : float):
	for sub : EventSubscriber in subscribers: await sub.display_dialogue(text, actor, await_input, seconds_before_close)

func cancel_dialogue(actor : String):
		for sub : EventSubscriber in subscribers: await sub.cancel_dialogue(actor)

func play_animation(animation : String, actor : String, await_animation : bool):
	for sub : EventSubscriber in subscribers: await sub.play_animation(animation, actor, await_animation)

func cancel_animation(actor : String):
	for sub : EventSubscriber in subscribers: await sub.cancel_animation(actor)
