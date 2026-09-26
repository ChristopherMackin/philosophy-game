# resource_generator.gd
@tool
extends EditorScript

func _run() -> void:
	print("--- Starting Resource & Scene Generation ---")
	
	var character_name:= "Heather"
	var debate_string:= "01"
	
	const DEBATE_SETTINGS = preload("uid://b51gfuqtvp857")
	
	var output_dir:= "res://debate/heather/db_01/"
	
	var suffix = "_db_%s_%s" % [character_name.to_lower(), debate_string]
	var base_scene_path: String = "res://_debug/lvl_db_debug_base.tscn"
	
	var bb_func: Callable = func(resource): pass
	var char_func: Callable = func(resource): pass
	var dk_func: Callable = func(resource): pass
	var ds_func: Callable = func(resource): resource = DEBATE_SETTINGS.duplicate(true)
	var ef_func: Callable = func(resource): pass
	
	var rtc: Dictionary = {
		"bb": {"resource_type": Blackboard, "initialize_function": bb_func},\
		"char": {"resource_type": Character, "initialize_function": char_func},\
		"dk": {"resource_type": InfiniteDeck, "initialize_function": dk_func},\
		"ds": {"resource_type": DebateSettings, "initialize_function": ds_func},\
		"ef": {"resource_type": BucketEventFactory, "initialize_function": ef_func}
	}

	if not ResourceLoader.exists(base_scene_path):
		print("ERROR: Base scene not found at ", base_scene_path)
		return
		
	var base_scene: PackedScene = load(base_scene_path)
	
	for folder in [output_dir]:
		if not DirAccess.dir_exists_absolute(folder):
			DirAccess.make_dir_recursive_absolute(folder)
			print("Created folder: ", folder)
	
	for key in rtc:
		var resource = rtc[key]["resource_type"].new()
		rtc[key]["initialize_function"].call(resource)
		var scene_path: String = output_dir + key + suffix + ".tres"
		var save_err: Error = ResourceSaver.save(resource, scene_path)
		if save_err == OK:
			print(key + " resource created")
		else:
			print("Failed to save %s resource" % key)
	
	var scene_instance: Node = base_scene.instantiate(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
	
	var inherited_scene: PackedScene = PackedScene.new()
	var pack_err: Error = inherited_scene.pack(scene_instance)
	
	if pack_err == OK:
		var scene_path: String = output_dir + "lvl" + suffix + ".tscn"
		var save_err: Error = ResourceSaver.save(inherited_scene, scene_path)
		
		if save_err == OK:
			print("lvl inherited scene created")
		else:
			print("Failed to save inherited scene")
	else:
		print("Failed to pack base scene")
		
	scene_instance.queue_free()
			
	print("--- Generation Complete! ---")
	
	EditorInterface.get_resource_filesystem().scan()
