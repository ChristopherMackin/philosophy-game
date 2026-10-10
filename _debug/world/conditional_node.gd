@tool
class_name ConditionalNode
extends Node

@export var rule: Rule
@export_enum("Destroy", "Hide", "SetVisible") var mode: int
@export var change_on_blackboard_update: bool = true

func _enter_tree() -> void:
	var root = get_parent()
	root.process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	Util.optional_connect(Global, "blackboard_updated", _on_blackboard_updated)

func _scene_added():
	_set_state()

func _on_blackboard_updated():
	if !change_on_blackboard_update: return
	_set_state()

func _set_state():
	var root = get_parent()
	var val = rule.check(Global.blackboard.get_query())
	root.process_mode = Node.PROCESS_MODE_INHERIT if val else Node.PROCESS_MODE_DISABLED
	
	if mode == 2:
		root.visible = val
		return
	
	if val: return
	
	root.process_mode = Node.PROCESS_MODE_DISABLED
	
	match mode:
		0:
			if Engine.is_editor_hint(): return
			root.queue_free()
			queue_free()
		1:
			root.visible = false
