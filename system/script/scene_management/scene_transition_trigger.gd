extends Area3D

@export var scene_name: String
@export var transition: PackedScene

func _ready():
	body_entered.connect(transition_scene)

func transition_scene(node: Node3D):
	print("TEST")
	SceneManager.replace_scene_async(scene_name, transition)
