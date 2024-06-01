extends Object

class_name AwaitAll

signal all_finished
signal finished

var completed : int = 0
var function_count : int

func _init(functions : Array[Callable]):
	finished.connect(complete)
	
	function_count = functions.size()
	for function : Callable in functions:
		run_async(function)

func run_async(function : Callable):
	await function.call()
	finished.emit()

func complete():
	completed += 1
	if completed >= function_count:
		all_finished.emit()
