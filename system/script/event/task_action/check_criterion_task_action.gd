extends TaskAction

class_name CheckCriterionTaskAction

func invoke(task : Task, manager : EventManager):
	var query: Dictionary
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(manager.blackboard.get_query())
	
	var criterion := Criterion.new()
	criterion.expression = task.get_input(0)
	
	if criterion.check(query):
		on_action_complete.emit(task.get_output(0))
	else:
		on_action_complete.emit(task.get_output(1))
