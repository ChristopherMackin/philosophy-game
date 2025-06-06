extends Resource

class_name TaskAction

signal on_action_complete(next_index : int)

func invoke(_task : Task, _manager : EventManager):
	on_action_complete.emit(-1)

func cancel(_task : Task, _manager : EventManager):
	on_action_complete.emit(-1)
