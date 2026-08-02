@tool
extends Resource

class_name EventManager

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
	
	if event.is_major_event:
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

func _start_event(event: Event):
	for sub : EventSubscriber in subscribers: await sub._start_event(event)

func _end_event(event: Event):
	for sub : EventSubscriber in subscribers: await sub._end_event(event)

func display_dialogue(dp: DialoguePayload):
	var callables: Array[Callable]
	callables.assign(subscribers.map(func(sub): return func(): await sub.display_dialogue(dp)))
	
	await Util.await_all(
		callables
	)

func cancel_dialogue(actor : String):
	for sub : EventSubscriber in subscribers: await sub.cancel_dialogue(actor)

func play_animation(animation : String, actor : String, overwrite_animation: bool, await_animation : bool):
	for sub : EventSubscriber in subscribers: await sub.play_animation(animation, actor, overwrite_animation, await_animation)

func cancel_animation(actor : String):
	for sub : EventSubscriber in subscribers: await sub.cancel_animation(actor)

func add_status_effect(effect: StatusEffect, which_player: Const.Player = Const.Player.HUMAN):
	for sub : EventSubscriber in subscribers: await sub.add_status_effect(effect, which_player)

func remove_status_effect(effect: StatusEffect, which_player: Const.Player = Const.Player.HUMAN):
	for sub : EventSubscriber in subscribers: await sub.remove_status_effect(effect, which_player)
	
func queue_event(event: Event):
	pass
