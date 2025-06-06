extends TaskAction

class_name DecrementTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var path = task.get_input(0)
	var bb : Blackboard = ResourceLoader.load(path)
	
	var value = bb.get_value(task.get_input(1))
	value -= 1
	
	bb.add(task.get_input(1), value)
	
	ResourceSaver.save(bb, path)
	
	return task.get_output(0)
