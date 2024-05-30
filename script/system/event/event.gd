extends Resource

class_name Event

#List of event tree indexes to branch to
@export var outputs : Array[int] = []
@export var inputs : Array = []
@export var action : EventAction

func invoke(manager : EventManager) -> int:
	return await action.invoke(self, manager)

func set_event_connections(inputs : Array, outputs : Array[int]):
	self.inputs = inputs
	self.outputs = outputs

func get_input(index : int):
	if range(inputs.size()).has(index): 
		return inputs[index]
	else:
		return null

func get_output(index : int) -> int:
	if range(outputs.size()).has(index): 
		return outputs[index]
	else:
		return -1
