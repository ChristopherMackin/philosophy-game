class_name ConditionalNode
extends Node

@export var root: Node
@export var rule: Rule

func _scene_added():
	if !rule.check(Global.blackboard.get_query()): root.queue_free()
	queue_free()
