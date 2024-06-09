@tool
extends Resource

class_name StateDatabase

@export var keys : Array[String]:
	get: return keys
	set(value):
		var keys_to_add = difference(value, keys)
		for key in keys_to_add:
			_dictionary[key] = null
		
		var keys_to_remove = difference(keys, value)
		for key in keys_to_remove:
			_dictionary.erase(key)
		keys = value

@export var _dictionary : Dictionary

var value : Dictionary:
	get: return _dictionary.duplicate()

func update(key : String, value):
	if _dictionary.has(key):
		_dictionary[key] = value

func clear():
	_dictionary.clear()
	for k in keys:
		_dictionary[k] = null

static func difference(arr1 : Array, arr2 : Array):
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1
