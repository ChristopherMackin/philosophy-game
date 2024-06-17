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
@export var value : String
var _value:
	get: return str_to_var(value)

func check(query : Dictionary) -> bool:
	return false

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
