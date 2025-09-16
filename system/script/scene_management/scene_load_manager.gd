extends Node

@export var spawn_locations: Array[Node3D]
@export var joy: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = GlobalBlackboard.blackboard.get_value("spawn_index")
	if index != null && index < spawn_locations.size():
		joy.position = spawn_locations[index].position
