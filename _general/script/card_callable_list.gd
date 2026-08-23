extends Object

class_name CardCallableList

var sorted_callables: SortedArray

func _init():
	var sort_func = func(x, y): return x.val2 < y.val2
	sorted_callables = SortedArray.new(sort_func)

func add_listener(callable: Callable, priority: int = 999):
	var tuple = Tuple.new(callable, priority)
	sorted_callables.add(tuple)

func remove_listener(callable: Callable):
	var index = sorted_callables.values.find_custom(func(x): return x.val1 == callable)
	if index >= 0: sorted_callables.remove_at(index)

func invoke(card: Card):
	for tuple in sorted_callables.values:
		await tuple.val1.call(card)
