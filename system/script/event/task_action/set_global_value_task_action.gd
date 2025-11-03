extends TaskAction

class_name SetGlobalValueTaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, manager : EventManager):
	var bb : Blackboard = GlobalBlackboard.blackboard
	
	bb.add(task.get_input(0), str_to_var(task.get_input(1)))
	
	on_action_complete.emit(task.get_output(0))
