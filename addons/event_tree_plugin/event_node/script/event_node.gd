@tool
extends GraphNode

class_name EventNode

var event : Event

func _enter_tree():
	print("NODE TYPE %S NEEDS TO CREATE NODE TYPE IN _enter_tree" % typeof(self))

func update(connected_events : Array[Event]):
	pass
