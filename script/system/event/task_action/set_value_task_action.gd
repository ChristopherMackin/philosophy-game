extends TaskAction

class_name SetValueTaskAction

func invoke(task : Task, manager : EventManager):
	var path = task.get_input(0)
	var bb : Blackboard = ResourceLoader.load(path)
	
	bb.add(task.get_input(1), task.get_input(2))
	
	ResourceSaver.save(bb, path)
	
	on_action_complete.emit(task.get_output(0))
