extends TaskAction

class_name CheckCriterionTaskAction

func invoke(task : Task, manager : EventManager):
	var query : Dictionary
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(manager.blackboard.get_query())
	
	if evaluate(task.get_input(0), query.keys(), query.values()):
		on_action_complete.emit(task.get_output(1))
	else:
		on_action_complete.emit(task.get_output(0))

func evaluate(command, variable_names = [], variable_values = []) -> bool:
	var expression = Expression.new()
	
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return false

	var result = expression.execute(variable_values, self)

	if expression.has_execute_failed():
		return false

	return result
