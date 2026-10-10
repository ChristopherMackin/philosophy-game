@abstract
class_name SceneLoader

extends Resource

func set_scene_state(slm: SceneLoadManager):
	_set_player_spawn(slm.character_controllers, slm.spawn_locations)

func _set_player_spawn(character_controllers: Array[CharacterBody3D], spawn_locations: Array[Node3D]):
	if spawn_locations.size() <= 0: return
	
	var spawn_index = 0
	if Global.blackboard.has_flag(Flag.SPAWN_INDEX):
		spawn_index = Global.blackboard.get_flag_value(Flag.SPAWN_INDEX)
		spawn_index = spawn_index if spawn_index < spawn_locations.size() else 0
	
	var spawn = spawn_locations[spawn_index]
	
	for character_controller in character_controllers:
		character_controller.global_position = spawn.global_position
		character_controller.global_rotation = spawn.global_rotation
