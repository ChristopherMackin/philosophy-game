# resource_generator.gd
@tool
extends EditorScript

func _run() -> void:
	print("--- Starting Resource & Scene Generation ---")
	
	var world_name:= "webber_household/main_room"
	var split_name:= world_name.split("/", false)
	var lvl_name := split_name[split_name.size() - 1]
	
	var output_dir:= "res://world/%s/" % [world_name]
	var suffix:= "_world_%s" % [lvl_name]
	
	var base_scene_path: String = "res://world/base/lvl_world_base.tscn"
	
	var bb_func: Callable = func(resource): return resource
	var ef_func: Callable = func(resource): return resource
	
	var rtc: Dictionary = {
		"bb": {"resource_type": Blackboard, "initialize_function": bb_func},\
		"ef": {"resource_type": BucketEventFactory, "initialize_function": ef_func}
	}
	
	create_text_file("%srm%s.txt" % [output_dir, suffix])

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
		resource = rtc[key]["initialize_function"].call(resource)
		var scene_path: String = output_dir + key + suffix + ".tres"
		var save_err: Error = ResourceSaver.save(resource, scene_path)
		if save_err == OK:
			print(key + " resource created")
		else:
			print("Failed to save %s resource" % key)
	
	var inherited_scene: PackedScene = create_inherited_scene(base_scene, "WorldLevel")
	
	var scene_path: String = output_dir + "lvl" + suffix + ".tscn"
	var save_err: Error = ResourceSaver.save(inherited_scene, scene_path)
	
	if save_err == OK:
		print("lvl inherited scene created")
	else:
		print("Failed to save inherited scene")
		
			
	print("--- Generation Complete! ---")
	
	EditorInterface.get_resource_filesystem().scan()

func create_text_file(path: String, content: String = ""):
	# Open the file in WRITE mode (creates the file if it doesn't exist)
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(content)
		file.close() # Always close the file to save changes
		print("File created successfully at: ", path)
	else:
		print("Failed to create file. Error code: ", FileAccess.get_open_error())

func create_inherited_scene(_inherits: PackedScene, _root_name: String = "") -> PackedScene:
	if(_root_name == ""): return
	
	_root_name = _inherits._bundled["names"][0];
	var scene := PackedScene.new();
	scene._bundled = {"base_scene": 0, "conn_count": 0, "conns": [], "editable_instances": [], 
			"names": [_root_name], "node_count": 1, "node_paths": [], 
			"nodes": [-1, -1, 2147483647, 0, -1, 0, 0], 
			"variants": [_inherits], "version": 2};
	return scene;
