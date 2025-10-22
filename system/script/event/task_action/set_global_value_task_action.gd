extends TaskAction

class_name SetGlobalValueTaskAction

func invoke(task : Task, manager : EventManager):
	var bb : Blackboard = GlobalBlackboard.blackboard
	
	bb.add(task.get_input(0), task.get_input(1))
	
	#ResourceSaver.save(bb, path)
	
	on_action_complete.emit(task.get_output(0))
