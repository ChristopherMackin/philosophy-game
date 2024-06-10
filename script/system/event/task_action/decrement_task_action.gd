extends TaskAction

class_name DecrementTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var path = task.get_input(0)
	var database : StateDatabase = ResourceLoader.load(path)
	
	if(!database):
		return task.get_output(0)
	
	var key = task.get_input(1)
	var col : DatabaseColumn = database.get_column(key)
	
	if col and col.type == TYPE_INT:
		if !database.value.has(key):
			database.update_value(key, -1)
		else:
			var value = database.value[key]
			value -= 1
			database.update_value(key, value)
	
	ResourceSaver.save(database, path)
	
	return task.get_output(0)
