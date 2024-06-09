@tool
extends Resource

class_name StateDatabase

@export var columns : Array[DatabaseColumn]

@export var _dictionary : Dictionary

var value : Dictionary:
	get: return _dictionary.duplicate()

func update(key : String, value) -> bool:
	for col in columns:
		if col.key == key:
			if typeof(value) == col.type:
				_dictionary[key] = value
				return true
			else:
				return false
	
	return false

func clean_up():
	var col_keys = columns.map(func(x): return x.key)
	var dic_keys = _dictionary.keys
	
	var keys_to_remove = difference(dic_keys, col_keys)
	
	for k in keys_to_remove:
		_dictionary.erase(k)

func clear():
	_dictionary.clear()

func difference(arr1, arr2):
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1
