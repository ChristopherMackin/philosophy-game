extends TaskAction

class_name SetMemoryTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var path = task.get_input(0)
	var memory : StateDatabase = ResourceLoader.load(path)
	var key = task.get_input(1)
	var value = str_to_var(task.get_input(2))
	memory.update(key, value)
	
	ResourceSaver.save(memory, path)
	
	return task.get_output(0)
