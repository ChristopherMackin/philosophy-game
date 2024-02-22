extends Node

class_name Queue

var _array : Array = []

func push(element):
	_array.append(element)

func pop():
	if _array.size() <= 0:
		return null
	
	return _array.pop_at(0)

func size():
	return _array.size()
