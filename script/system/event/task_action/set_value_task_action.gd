extends TaskAction

class_name SetValueTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var path = task.get_input(0)
	var database : StateDatabase = ResourceLoader.load(path)
	var key = task.get_input(1)
	var value = str_to_var(task.get_input(2))
	database.update_value(key, value)
	
	ResourceSaver.save(database, path)
	
	return task.get_output(0)
