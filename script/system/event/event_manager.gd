extends Resource

class_name EventManager

signal cancel_event

var subscriber_array : Array[EventSubscriber]
var current_event : Event
var task_index
var event_canceled = false

func subscribe(subscriber : EventSubscriber):
	subscriber_array.append(subscriber)
func unsubscribe(subscriber : EventSubscriber):
	var index = subscriber_array.find(subscriber)
	
	if index != -1:
		subscriber_array.remove_at(index)

func start_event(event : Event):
	if !event || (current_event && !event.is_major_event): return
	
	if current_event:
		cancel_event.emit()
	
	current_event = event
	if event.await_event:	
		await start_task_loop(event)
	else:
		start_task_loop(event)

func start_task_loop(event: Event):	
	var current_task := event.start_task
	task_index = null
	
	while current_task:
		task_index
		
		var func_array : Array[Callable] = [
			func(): task_index = await current_task.invoke(self),
			func(): 
				await cancel_event
				event_canceled = true
		]		
		
		await Util.await_any(func_array)
		
		if event_canceled:
			current_task.cancel
			event_canceled = false
			return
		
		current_task = event.get_task(task_index)
	
	current_event = null

func display_dialogue(text : String, actor : String, await_input : bool):
	for sub : EventSubscriber in subscriber_array: await sub.display_dialogue(text, actor)

func play_animation(name : String, actor : String, await_animation : bool):
	for sub : EventSubscriber in subscriber_array: await sub.play_animation(name, actor, await_animation)
