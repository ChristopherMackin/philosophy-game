class_name RuleSceneLoaderFactory

extends SceneLoaderFactory

@export var rule: Rule
@export var scene_loader: SceneLoader

func get_scene_loader(query: Dictionary) -> SceneLoader:
	if rule.check(query):
		return scene_loader
	
	return null
