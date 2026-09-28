extends Area3D



func _ready():
	body_entered.connect(transition_scene)

func transition_scene(node: Node3D):
	GlobalBlackboard.blackboard.add_flag(Flag.SPAWN_INDEX, spawn_index)
	SceneManager.replace_scene_async(scene_name, transition)
