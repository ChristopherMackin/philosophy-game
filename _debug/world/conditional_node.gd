@tool
class_name ConditionalNode
extends Node

@export var rule: Rule
@export_enum("Destroy", "Hide", "SetVisible") var mode: int

func _ready() -> void:
	Util.optional_connect(Global, "blackboard_updated", _set_state)

func _scene_added():
	_set_state()

func _set_state():
	var root = get_parent()
	if mode == 2:
		root.visible = rule.check(Global.blackboard.get_query())
		return
	
	if rule.check(Global.blackboard.get_query()): return
	
	match mode:
		0:
			if Engine.is_editor_hint(): return
			root.queue_free()
			queue_free()
		1:
			root.visible = false
