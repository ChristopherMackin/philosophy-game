extends Object

class_name SortedArray

var _values: Array
var _sort_function: Callable

var values: Array: 
	get: return _values.duplicate()

func _init(sort_function: Callable, initial_values: Array = []):
	_sort_function = sort_function
	_values = initial_values

func add(value):
	_values.append(value)
	_values.sort_custom(_sort_function)

func remove(value):
	var index = _values.find(value)
	if index >= 0:
		_values.remove_at(index)

func find(value): return _values.find(value)

func remove_at(index):
	_values.remove_at(index)

func get_value(index: int): return _values.get(index)

func get_card_index(card: Card): return _values.find(card)

func size(): return _values.size()
