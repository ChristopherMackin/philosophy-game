extends Resource

class_name Criterion

enum Comparator {
	EQUALS,
	NOT,
	GREATER,
	LESS,
	GREATER_EQUALS,
	LESS_EQUALS
}
 
@export var comparator : Criterion.Comparator

@export var key : String
@export var value : String
var _value:
	get: 
		var val = str_to_var(value)
		return val if typeof(val) != 0 else value.to_snake_case()

func check(query : Dictionary) -> bool:
	if !query.has(key):
		return false
	else: return query.get(key) == _value

func compare(value1, value2, comparator : Comparator) -> bool:
	if typeof(value1) != typeof(value2):
		return false
	
	match comparator:
		Comparator.EQUALS:
			return value1 == value2
		Comparator.NOT:
			return value1 != value2
		Comparator.GREATER:
			return value1 > value2
		Comparator.GREATER_EQUALS:
			return value1 >= value2
		Comparator.LESS:
			return value1 < value2
		Comparator.LESS_EQUALS :
			return value1 <= value2
		_:
			return false
