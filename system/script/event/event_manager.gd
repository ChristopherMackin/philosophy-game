@tool
extends Resource

class_name EventManager

signal queue_empty

@export var blackboard: Blackboard

var subscribers : Array[EventSubscriber]
var current_task : Task
var current_event : Event

var event_queue: Queue = Queue.new()

func subscribe(subscriber : EventSubscriber):
	var index = subscribers.find(subscriber)
	if index <= 0:
		subscribers.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscribers.find(subscriber)
	
	if index != -1:
		subscribers.remove_at(index)

func cancel_current_event():
	if current_task:
		current_task.cancel(self)
		await _end_event(current_event)
	
	current_task = null
	current_event = null

func start_event(event : Event):	
	if !event: return
	
	if event.await_queue:
		await queue_empty
	if event.can_interupt:
		await cancel_current_event()
	elif current_task:
		event_queue.push(event)
		return
	
	current_event = event
	current_task = event.start_task
	
	await _start_event(current_event)
	
	while current_task:
		var index
		if current_event.skip: index = await current_task.skip(blackboard, self)
		else: index = await current_task.invoke(blackboard, self)
		if !current_event: return
		current_task = current_event.get_task(index)
	
	var expire = current_event.get_expiration_token()
	if expire != null:
		blackboard.add(current_event.resource_path.get_file(), true, expire)
	
	await _end_event(current_event)
	
	if event_queue.size() > 0:
		start_event(event_queue.pop())
	else:
		queue_empty.emit()

func _start_event(event: Event):
	for sub : EventSubscriber in subscribers: await sub._start_event(event)

func _end_event(event: Event):
	for sub : EventSubscriber in subscribers: await sub._end_event(event)

func display_dialogue(dp: DialoguePayload):
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub: EventSubscriber): return func(): await sub.display_dialogue(dp)))
	
	await Util.await_all(
		callables
	)

func cancel_dialogue(actor : String):
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub: EventSubscriber): return func(): await sub.cancel_dialogue(actor)))
	
	await Util.await_all(
		callables
	)

func play_animation(animation : String, actor : String, overwrite_animation: bool, await_animation : bool):
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub: EventSubscriber): return func(): await sub.play_animation(animation, actor, overwrite_animation, await_animation)))
	
	await Util.await_all(
		callables
	)

func cancel_animation(actor : String):
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub: EventSubscriber): return func(): await sub.cancel_animation(actor)))
	
	await Util.await_all(
		callables
	)

func start_timer(seconds: float):
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub: EventSubscriber): return func(): await sub.start_timer(seconds)))
	
	await Util.await_all(
		callables
	)

func cancel_timer():
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub: EventSubscriber): return func(): await sub.cancel_timer()))
	
	await Util.await_all(
		callables
	)

func queue_event(event: Event):
	pass
