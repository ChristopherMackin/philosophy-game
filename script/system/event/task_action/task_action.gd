extends Resource

class_name TaskAction

signal on_action_complete(next_task_index : int)

func invoke(task : Task, manager : EventManager):
	on_action_complete.emit(1)

func cancel(task : Task, manager : EventManager):
	return
