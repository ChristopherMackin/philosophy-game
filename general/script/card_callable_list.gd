extends Object

class_name CardCallableList

var callables: Array[Callable]

func _init():
	callables = []

func add_listener(callable: Callable):
	callables.append(callable)

func remove_listener(callable: Callable):
	var index = callables.find(callable)
	if index >= 0: callables.remove_at(index)

func invoke(card: Card):
	for callable in callables:
		await callable.call(card)
