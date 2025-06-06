extends Resource

class_name SceneManifest

@export_global_file("*.tscn") var _scene_list: Array[String]
var scene_list: Array[String]:
	get: return _scene_list
