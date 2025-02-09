extends Resource

class_name SaveData

@export var path : String
var full_path:
	get: return Constants.save_path + path
@export var resource : Resource

func save_data(): 
	#ResourceSaver.save(resource, full_path)
	pass

func load_data():
	var saved_resource : Resource
	
	if ResourceLoader.exists(full_path):
		saved_resource = ResourceLoader.load(full_path, "", ResourceLoader.CACHE_MODE_REUSE`)
		print(saved_resource.composition_top_deck_config_array[0].count)
	else:
		ResourceSaver.save(resource, full_path)
