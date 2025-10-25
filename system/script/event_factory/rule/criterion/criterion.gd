@tool
extends Resource

class_name Criterion

@export_custom(PROPERTY_HINT_EXPRESSION, "") var expression : String = ""
@export var variables : Dictionary[String, Variant]

func check(query : Dictionary) -> bool:
	if expression.trim_prefix(" ") == "": return true
	
	var _query_and_variables = variables.duplicate()
	_query_and_variables.merge(query)
	return evaluate(expression, _query_and_variables.keys(), _query_and_variables.values())

func evaluate(command, variable_names = [], variable_values = []) -> bool:
	var expression := Expression.new()
	
	var error = expression.parse(command, variable_names)
	
	if error != OK:
		push_error(expression.get_error_text())
		return false
	
	var result = expression.execute(variable_values, self, false)
	
	while expression.has_execute_failed():
		#PLEASE NOTE: I KNOW THIS SUCKS BUT I DIDN'T WANNA DO A REWRITE OF GODOT FOR THIS, SO SHUT UP
		var error_text = expression.get_error_text()
		if !error_text.contains("Invalid named index"):
			return false
		
		variable_names.append(error_text.split("'")[1])
		variable_values.append(false)
		
		error = expression.parse(command, variable_names)
	
		result = expression.execute(variable_values, self, false)

	return result
