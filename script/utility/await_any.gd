extends Object

class_name AwaitAny

signal any_finished

var has_fired := false

func _init(functions : Array[Callable]):
	for function : Callable in functions:
		run_async(function)

func run_async(function : Callable):
	await function.call()
	finished()

func finished():
	if has_fired: return
	any_finished.emit()
	has_fired = true
