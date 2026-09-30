class_name ConditionalNode
extends Node

@export var root: Node
@export var rule: Rule
@export_enum("Destroy", "Hide") var mode: int

func _scene_added():
	if rule.check(Global.blackboard.get_query()): return
	
	match mode:
		0:
			root.queue_free()
			queue_free()
		1:
			root.visible = false
