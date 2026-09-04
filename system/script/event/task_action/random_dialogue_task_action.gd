@tool
extends TaskAction

class_name RandomDialogueTaskAction

func invoke(task : Task, manager : EventManager):	
	if(!task.get_input("line_array") is Array): return
	
	canceled = false
	
	var dialogue_array: Array
	dialogue_array.assign(task.get_input("line_array"))
	
	var text = dialogue_array.pick_random()
	
	
	await Util.await_any([
		#func(): await manager.display_dialogue(text, task.get_input(1), task.get_input(2), task.get_input(3)),
		func(): await on_action_canceled
	])
		
	if canceled:
		return
	
	on_action_complete.emit(task.get_output(0))

func cancel(task: Task, manager: EventManager):
	super.cancel(task, manager)
	manager.cancel_dialogue(task.get_input("actor"))
