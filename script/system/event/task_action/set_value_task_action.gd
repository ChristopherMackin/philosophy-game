extends TaskAction

class_name SetValueTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var path = task.get_input(0)
	var db : StateDatabase = ResourceLoader.load(path)
	var schema = db.schema
	
	var key = DBConst.db_schema_data[schema][task.get_input(1)].key
	var value = str_to_var(task.get_input(2))
	db.update_value(key, value)
	
	ResourceSaver.save(db, path)
	
	return task.get_output(0)
