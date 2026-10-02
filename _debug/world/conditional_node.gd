class_name ConditionalNode
extends Node

@export var rule: Rule
@export_enum("Destroy", "Hide", "SetVisible") var mode: int

func _scene_added():
	var root = get_parent()
	if mode == 2:
		root.visible = rule.check(Global.blackboard.get_query())
		print(rule.check(Global.blackboard.get_query()))
		return
	
	if rule.check(Global.blackboard.get_query()): return
	
	match mode:
		0:
			root.queue_free()
			queue_free()
		1:
			root.visible = false
