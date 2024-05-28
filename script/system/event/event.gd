extends Resource

class_name Event

@export var outputs : Array[Event] = []
@export var inputs : Array = []
@export var action : EventAction

func invoke(manager : EventManager) -> Event:
	return await action.invoke(self, manager)

func set_connections(inputs : Array, outputs : Array):
	self.inputs = inputs
	self.outputs = outputs

func get_input(index : int):
	if range(inputs.size()).has(index): 
		return inputs[index]
	else:
		return null

func get_output(index : int):
	if range(outputs.size()).has(index): 
		return outputs[index]
	else:
		return null
