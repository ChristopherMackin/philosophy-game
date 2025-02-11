extends Resource

class_name SaveData

@export var path : String
var full_path:
	get: return Constants.save_path + path
@export var resource : Resource

func save_data():
	ResourceSaver.save(resource, full_path)

func load_data():
	if !ResourceLoader.exists(full_path):
		DirAccess.make_dir_recursive_absolute(full_path.get_base_dir()) 
		ResourceSaver.save(resource, full_path)
		return
		
	var loaded_resource = ResourceLoader.load(full_path)
	var name_list = loaded_resource.get_property_list().filter(func(x): return x.usage == 4102).map(func(x): return x.name)

	for name in name_list:
		resource.set(name, loaded_resource.get(name))
