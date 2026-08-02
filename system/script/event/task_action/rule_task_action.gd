@tool
extends TaskAction

class_name ExpressionRuleTaskAction

func skip(task: Task, manager : EventManager):
	await invoke(task, manager)

func invoke(task : Task, manager : EventManager):
	var query: Dictionary
	query.merge(GlobalBlackboard.blackboard.get_query())
	query.merge(manager.blackboard.get_query())
	
	var rule = task.get_input("rule")
	
	if rule.check(query):
		on_action_complete.emit(task.get_output(0))
	else:
		on_action_complete.emit(task.get_output(1))
