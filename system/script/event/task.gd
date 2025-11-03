@tool
extends Resource

class_name Task

#List of task indexes to branch to
@export var outputs : Array[int] = []
@export var inputs : Array = []
@export var action : TaskAction

var blackboard: Blackboard

func skip(blackboard: Blackboard, manager : EventManager):
	self.blackboard = blackboard
	action.skip.call_deferred(self, manager)
	return await action.on_action_complete

func invoke(blackboard: Blackboard, manager : EventManager):
	self.blackboard = blackboard
	action.invoke.call_deferred(self, manager)
	return await action.on_action_complete

func cancel(manager: EventManager):
	action.cancel(self, manager)

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
