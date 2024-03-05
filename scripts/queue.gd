extends Node

class_name Queue

var _array : Array = []
var on_push : Callable

var array : Array:
	get: 
		return _array.duplicate(true)

func push(element):
	_array.append(element)
	
	if on_push:
		on_push.call()

func pop():
	if _array.size() <= 0:
		return null
	
	return _array.pop_at(0)

func size():
	return _array.size()
