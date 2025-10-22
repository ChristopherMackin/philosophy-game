@tool
extends Resource

class_name Criterion

@export_custom(PROPERTY_HINT_EXPRESSION, "") var expression : String = ""
@export var variables : Dictionary[String, Variant]

func check(query : Dictionary) -> bool:
	var _query_and_variables = variables.duplicate()
	_query_and_variables.merge(query)
	return evaluate(expression, _query_and_variables.keys(), _query_and_variables.values())

func evaluate(command, variable_names = [], variable_values = []) -> bool:
	var expression = Expression.new()
	
	var error = expression.parse(command, variable_names)
	if error != OK:
		push_error(expression.get_error_text())
		return false

	var result = expression.execute(variable_values, self)

	if expression.has_execute_failed():
		return false

	return result == "true"
