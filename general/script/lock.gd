extends Object

class_name Lock

signal on_released

var locked : bool = false

func obtain_lock():
	if locked:
		return false
	
	locked = true
	return true

func release_lock():
	locked = false
	on_released.emit()
