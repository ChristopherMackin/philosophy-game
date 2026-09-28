class_name BucketSceneLoaderFactory
extends SceneLoaderFactory

@export var buckets: Array[SceneLoaderFactory] = []

func get_scene_loader(query: Dictionary) -> SceneLoader:
	for bucket in buckets:
		var loader = bucket.get_scene_loader(query)
		if loader:
			return loader
	
	return null
