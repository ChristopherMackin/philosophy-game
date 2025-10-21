extends Resource

class_name EventManager

var blackboard: Blackboard

var subscribers : Array[EventSubscriber]
var current_task : Task
var current_event : Event

func subscribe(subscriber : EventSubscriber):
	subscribers.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscribers.find(subscriber)
	
	if index != -1:
		subscribers.remove_at(index)

func start_event(event : Event):
	if event.skip: return
	
	if !event || (current_task && !event.can_interupt): return
	
	if current_task:
		current_task.cancel(self)
		await _end_event(current_event)
	
	current_event = event
	current_task = event.start_task
	
	await _start_event(current_event)
	
	while current_task:
		var index = await current_task.invoke(blackboard, self)
		current_task = current_event.get_task(index)
	
	var expire = current_event.get_expiration_token()
	if expire != null:
		blackboard.add(current_event.resource_path.get_file(), true, expire)
	
	await _end_event(current_event)

func _start_event(event: Event):
	for sub : EventSubscriber in subscribers: await sub._start_event(event)

func _end_event(event: Event):
	for sub : EventSubscriber in subscribers: await sub._end_event(event)

func display_dialogue(text : String, actor : String, await_input : bool, seconds_before_close : float):
	for sub : EventSubscriber in subscribers: await sub.display_dialogue(text, actor, await_input, seconds_before_close)

func cancel_dialogue(actor : String):
	for sub : EventSubscriber in subscribers: await sub.cancel_dialogue(actor)

func play_animation(animation : String, actor : String, overwrite_animation: bool, await_animation : bool):
	for sub : EventSubscriber in subscribers: await sub.play_animation(animation, actor, overwrite_animation, await_animation)

func cancel_animation(actor : String):
	for sub : EventSubscriber in subscribers: await sub.cancel_animation(actor)
