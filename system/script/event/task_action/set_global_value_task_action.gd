@tool
extends TaskAction

class_name SetGlobalValueTaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, _manager : EventManager):
	var bb : Blackboard = GlobalBlackboard.blackboard
	
	#TODO: Make this a searchable enumerable flag list
	bb.add(task.get_input("key"), str_to_var(task.get_input("val")))
	
	on_action_complete.emit(task.get_output(0))
