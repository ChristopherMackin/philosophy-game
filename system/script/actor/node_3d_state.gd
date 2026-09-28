class_name Node3dState
extends Resource

@export var node_path: NodePath
@export var global_position: Vector3
@export var global_rotation: Vector3

static func get_state(node: Node3D) -> Node3dState:
	var state = Node3dState.new()
	
	state.node_path = node.get_path()
	state.global_position = node.global_position
	state.global_rotation = node.global_rotation
	return state

func set_state(node: Node3D):
	node.global_position = global_position
	node.global_rotation = global_rotation
